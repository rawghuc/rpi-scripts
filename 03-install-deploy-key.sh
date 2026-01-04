#!/usr/bin/env bash
set -euo pipefail
source ./00-common.sh

DEPLOY_KEY="-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----"

RUN_USER="${SUDO_USER:-}"

echo "Run User: $RUN_USER"

HOME_DIR="/home/${RUN_USER}"
SSH_DIR="${HOME_DIR}/.ssh"
KEY_FILE="${SSH_DIR}/id_rsa"
KNOWN_HOSTS="${SSH_DIR}/known_hosts"

log "Installing Git deploy key for user: ${RUN_USER}"

# ---------------------------
# Sanity checks
# ---------------------------
if [ -z "${DEPLOY_KEY:-}" ]; then
  error "DEPLOY_KEY is not set"
  exit 1
fi

if [ ! -d "$HOME_DIR" ]; then
  error "Home directory ${HOME_DIR} does not exist"
  exit 1
fi

# ---------------------------
# Create .ssh directory securely
# ---------------------------
log "Setting up SSH directory"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$RUN_USER:$RUN_USER" "$SSH_DIR"

# ---------------------------
# Install deploy private key
# ---------------------------
log "Writing deploy private key"

echo "$DEPLOY_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
chown "$RUN_USER:$RUN_USER" "$KEY_FILE"

# ---------------------------
# Add GitHub to known_hosts (SAFE METHOD)
# ---------------------------
log "Adding github.com to known_hosts"

su - "$RUN_USER" -c "ssh-keyscan github.com | tee -a ~/.ssh/known_hosts >/dev/null"

chmod 644 "$KNOWN_HOSTS"
chown "$RUN_USER:$RUN_USER" "$KNOWN_HOSTS"

# ---------------------------
# Verification: Test SSH auth
# ---------------------------
log "Verifying GitHub SSH authentication"

set +e
SSH_TEST_OUTPUT=$(su - "$RUN_USER" -c "ssh -T git@github.com" 2>&1)
SSH_TEST_RC=$?
set -e

if echo "$SSH_TEST_OUTPUT" | grep -q "successfully authenticated"; then
  log "GitHub SSH authentication verified successfully"
else
  error "GitHub SSH authentication failed"
  echo "---- ssh output ----"
  echo "$SSH_TEST_OUTPUT"
  echo "--------------------"
  exit 1
fi

log "Deploy key installation completed successfully"
