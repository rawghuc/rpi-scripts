#!/usr/bin/env bash
source ./00-common.sh

log "Updating system & installing base packages..."
apt update && apt upgrade -y

apt install -y git python3 python3-pip python3-dev build-essential curl jq network-manager

log "Installing Mosquitto..."
apt install -y mosquitto mosquitto-clients
systemctl enable mosquitto
systemctl restart mosquitto
