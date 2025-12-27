#!/usr/bin/env bash
source ./00-common.sh

TS_KEY="tskey-auth-k5AfVvQjR721CNTRL-4it3NMxFSCZS3xc3Ny2oBZCCoTqqYjfz"
DEVICE_ID=$(cat /tmp/device_id)

curl -fsSL https://tailscale.com/install.sh | sh

log "Joining Tailscale..."
tailscale up --auth-key "$TS_KEY" --hostname "$DEVICE_ID" || true

sleep 2
TS_IP=$(tailscale ip -4 | head -n1)
echo "$TS_IP" >/tmp/tailscale_ip

log "Tailscale IP: $TS_IP"
