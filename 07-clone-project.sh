#!/usr/bin/env bash
source ./00-common.sh

RUN_USER="${SUDO_USER:-}"
REPO="git@github.com:Innoway-Technologies-OPC-Pvt-Ltd/rpiserver.git"
BRANCH="deploy-rpi"

log "Cloning repo..."

su - $RUN_USER -c "
  mkdir -p ~/flaskserver
  cd ~/flaskserver
  git clone $REPO . || true
  git fetch origin
  git checkout $BRANCH
"
