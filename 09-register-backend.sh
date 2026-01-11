#!/usr/bin/env bash
source ./00-common.sh

BACKEND_URL="https://parksense.co.in/api/v1/device/test-registration/"

DEVICE_ID=$(cat /tmp/device_id)
DEVICE_NAME=$(cat /tmp/device_name)
TS_IP=$(cat /tmp/tailscale_ip)
SERIAL=$(get_serial)
LOCAL_IP=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(cat /sys/class/net/wlan0/address)

POST=$(jq -n \
  --arg pl_rpi_mac "$MAC_ADDR" \
  --arg subpath "$DEVICE_ID" \
  --arg pl_name "$DEVICE_NAME" \
  --arg serial "$SERIAL" \
  --arg vpn_ip_address "$TS_IP" \
  --arg pl_rpi_local_ip "$LOCAL_IP" \
  '{subpath:$subpath,pl_name:$pl_name,serial:$serial,vpn_ip_address:$vpn_ip_address,pl_rpi_local_ip:$pl_rpi_local_ip}')

log "Registering with backend: $BACKEND_URL"
RESP=$(curl -s -X POST -H 'Content-Type: application/json' -d "$POST" "$BACKEND_URL")

echo "Response:\n{$RESP}"

# Extract values
echo "$RESP" >/tmp/backend_response.json
