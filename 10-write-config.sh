#!/usr/bin/env bash
source ./00-common.sh
source /etc/cust_info/cust_info.env

DEVICE_ID=$(cat /tmp/device_id)
DEVICE_NAME=$(cat /tmp/device_name)
TS_IP=$(cat /tmp/tailscale_ip)
RUN_USER="${SUDO_USER:-}"

MQTT_USER=$(jq -r '.mqtt_username // "mqtt_user"' /tmp/backend_response.json)
MQTT_PASS=$(jq -r '.mqtt_password // "mqtt_pass"' /tmp/backend_response.json)

RPI_UUID=$(jq -r '.rpi_uuid // ""' /tmp/backend_response.json)

# CUSTOMER=$(jq -r '.customer // ""' /tmp/backend_response.json)
# LOCATION=$(jq -r '.location // ""' /tmp/backend_response.json)
# DESCRIPTION=$(jq -r '.description // ""' /tmp/backend_response.json)
SLOTS=$(jq -c '.slots // {}' /tmp/backend_response.json)

cat >/home/$RUN_USER/flaskserver/.env <<EOF
DEVICE_NAME=$RPI_NAME
DEVICE_ID=$DEVICE_ID
MQTT_USERNAME=$MQTT_USER
MQTT_PASSWORD=$MQTT_PASS
TAILSCALE_IP=$TS_IP
EOF

cat >/home/$RUN_USER/flaskserver/config.json <<EOF
{
  "device_name": "$RPI_NAME",
  "customer": "$CUST_ID",
  "status": "active",
  "location": "$LOCATION",
  "description": "$RPI_DESC",
  "rpi_uuid": "$RPI_UUID",
  "registered_park_slots": $SLOTS
}
EOF
