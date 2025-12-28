#!/usr/bin/env bash
set -euo pipefail
source ./00-common.sh

# Detect runtime user
RUN_USER="${SUDO_USER:-}"
RUN_USER="${RUN_USER:-pi}"

PROJECT_DIR="/home/${RUN_USER}/flaskserver"
VENV_DIR="${PROJECT_DIR}/venv"
REQ_FILE="${PROJECT_DIR}/requirements.txt"

log "Setting up Python virtual environment at ${VENV_DIR}"

# Create venv if not exists
if [ ! -d "$VENV_DIR" ]; then
  log "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

# Upgrade pip inside venv
log "Upgrading pip inside venv..."
"$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel

# Install requirements
if [ -f "$REQ_FILE" ]; then
  log "Installing Python dependencies inside venv..."
  "$VENV_DIR/bin/pip" install -r "$REQ_FILE"
else
  error "requirements.txt not found at $REQ_FILE"
  exit 1
fi

# Fix ownership (important!)
chown -R "$RUN_USER:$RUN_USER" "$VENV_DIR"

log "Virtual environment setup completed"
