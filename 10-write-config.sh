#!/usr/bin/env bash
source ./00-common.sh

DEVICE_ID=$(cat /tmp/device_id)
DEVICE_NAME=$(cat /tmp/device_name)
TS_IP=$(cat /tmp/tailscale_ip)

MQTT_USER=$(jq -r '.mqtt_username // "mqtt_user"' /tmp/backend_response.json)
MQTT_PASS=$(jq -r '.mqtt_password // "mqtt_pass"' /tmp/backend_response.json)

LOCATION=$(jq -r '.location // ""' /tmp/backend_response.json)
DESCRIPTION=$(jq -r '.description // ""' /tmp/backend_response.json)
SLOTS=$(jq -c '.slots // {}' /tmp/backend_response.json)

cat >/home/pi/flaskserver/.env <<EOF
DEVICE_NAME=$DEVICE_NAME
DEVICE_ID=$DEVICE_ID
MQTT_USERNAME=$MQTT_USER
MQTT_PASSWORD=$MQTT_PASS
TAILSCALE_IP=$TS_IP
EOF

cat >/home/pi/flaskserver/config.json <<EOF
{
  "device_name": "$DEVICE_NAME",
  "customer": "Innoway",
  "status": "active",
  "location": "$LOCATION",
  "description": "$DESCRIPTION",
  "rpi_uuid": "$(get_serial)",
  "registered_park_slots": $SLOTS
}
EOF
