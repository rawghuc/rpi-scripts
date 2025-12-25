#!/usr/bin/env bash
source ./00-common.sh

BACKEND_URL="$1"

DEVICE_ID=$(cat /tmp/device_id)
DEVICE_NAME=$(cat /tmp/device_name)
TS_IP=$(cat /tmp/tailscale_ip)
SERIAL=$(get_serial)
LOCAL_IP=$(hostname -I | awk '{print $1}')

POST=$(jq -n \
  --arg id "$DEVICE_ID" \
  --arg name "$DEVICE_NAME" \
  --arg serial "$SERIAL" \
  --arg ts "$TS_IP" \
  --arg local "$LOCAL_IP" \
  '{device_id:$id,device_name:$name,serial:$serial,tailscale_ip:$ts,local_ip:$local}')

log "Registering with backend: $BACKEND_URL"
RESP=$(curl -s -X POST -H 'Content-Type: application/json' -d "$POST" "$BACKEND_URL")

# Extract values
echo "$RESP" >/tmp/backend_response.json
