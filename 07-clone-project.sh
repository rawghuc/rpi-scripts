#!/usr/bin/env bash
set -euo pipefail
source ./00-common.sh

# ---------------------------------
# Detect runtime user safely
# ---------------------------------
RUN_USER="${SUDO_USER:-}"

if [ -z "$RUN_USER" ]; then
  RUN_USER="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1; exit}' /etc/passwd)"
fi

RUN_USER="${RUN_USER:-pi}"

REPO="git@github.com:Innoway-Technologies-OPC-Pvt-Ltd/rpiserver.git"
BRANCH="deploy-rpi"
PROJECT_DIR="/home/${RUN_USER}/flaskserver"

log "Preparing to clone repo for user: $RUN_USER"

# ---------------------------------
# 1. Wait for DNS/network
# ---------------------------------
log "Waiting for network/DNS to become ready..."

for i in {1..20}; do
  if getent hosts github.com >/dev/null 2>&1; then
    log "DNS resolution working."
    break
  fi
  log "DNS not ready yet (attempt $i/20). Waiting..."
  sleep 3
done

if ! getent hosts github.com >/dev/null 2>&1; then
  error "DNS never became ready. Aborting clone."
  exit 1
fi

# ---------------------------------
# 2. Prepare SSH known_hosts
# ---------------------------------
log "Ensuring GitHub is in known_hosts..."

su - "$RUN_USER" -c "
  mkdir -p ~/.ssh
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
"

# ---------------------------------
# 3. Clone repo with retry logic
# ---------------------------------
log "Cloning repository..."

su - "$RUN_USER" -c "
  set -e
  mkdir -p ~/flaskserver
  cd ~/flaskserver

  if [ ! -d .git ]; then
    for i in {1..5}; do
      echo \"Clone attempt \$i...\"
      git clone \"$REPO\" . && break
      sleep 5
    done
  fi
"

# ---------------------------------
# 4. Verify clone succeeded
# ---------------------------------
if [ ! -d "${PROJECT_DIR}/.git" ]; then
  error "Repository clone failed after retries."
  exit 1
fi

# ---------------------------------
# 5. Checkout correct branch
# ---------------------------------
log "Checking out branch: $BRANCH"

su - "$RUN_USER" -c "
  cd ~/flaskserver
  git fetch origin
  git checkout $BRANCH
"

log "Repository cloned and branch checked out successfully."
