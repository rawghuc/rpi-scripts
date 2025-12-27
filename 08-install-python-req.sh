#!/usr/bin/env bash
source ./00-common.sh

RUN_USER="${SUDO_USER:-}"

REQ_FILE="/home/$RUN_USER/flaskserver/requirements.txt"
log "Starting... with $RUN_USER"

if [ -f "$REQ_FILE" ]; then
  log "Installing Python dependencies..."
  pip3 install -r "$REQ_FILE" --break-system-packages
else
  log "Failed..."
  error "No requirements.txt found."
fi
