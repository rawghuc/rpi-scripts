#!/usr/bin/env bash
source ./00-common.sh
source /etc/cust_info/cust_info.env

BACKEND_URL="https://parksense.co.in/api/v1/device/register-pl-rpi/"

DEVICE_ID=$(cat /tmp/device_id)
DEVICE_NAME=$(cat /tmp/device_name)
TS_IP=$(cat /tmp/tailscale_ip)
# SERIAL=$(get_serial)
LOCAL_IP=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(cat /sys/class/net/wlan0/address)

POST='{
  "cust_id": "'"$CUST_ID"'",
  "pl_name": "'"$RPI_NAME"'",
  "description": "'"$RPI_DESC"'",
  "pl_rpi_mac": "'"$MAC_ADDR"'",
  "subpath": "'"$SUBPATH"'",
  "location": "'"$LOCATION"'",
  "ssh_username": "'"$SSH_USER"'",
  "ssh_password": "'"$SSH_PASS"'",
  "vpn_ip_address": "'"$TS_IP"'",
  "pl_rpi_local_ip": "'"$LOCAL_IP"'"
}'

#log "Registering with backend: $BACKEND_URL"
echo "post body: $POST"

RESP=$(curl -s -X POST \
  -H 'Content-Type: application/json' \
  -d "$POST" \
  "$BACKEND_URL")

log "Registering with backend: $BACKEND_URL"
RESP=$(curl -s -X POST -H 'Content-Type: application/json' -d "$POST" "$BACKEND_URL")

echo "Response:\n{$RESP}"

# Extract values
echo "$RESP" >/tmp/backend_response.json
