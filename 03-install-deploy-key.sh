#!/usr/bin/env bash
source ./00-common.sh

DEPLOY_KEY="$1"
RUN_USER="$2"

log "Installing deploy key for Git..."

mkdir -p /home/$RUN_USER/.ssh
echo "$DEPLOY_KEY" >/home/$RUN_USER/.ssh/id_rsa
chmod 600 /home/$RUN_USER/.ssh/id_rsa
chown $RUN_USER:$RUN_USER /home/$RUN_USER/.ssh/id_rsa

su - $RUN_USER -c "ssh-keyscan github.com >> ~/.ssh/known_hosts"
