#!/usr/bin/env bash
source ./00-common.sh

SERIAL=$(get_serial)
SHORT=$(get_short_serial)

DEVICE_ID="parking-$SHORT"
DEVICE_NAME="Parking-RPi-$SHORT"

echo "$DEVICE_ID" >/tmp/device_id
echo "$DEVICE_NAME" >/tmp/device_name

log "Generated DEVICE_ID=$DEVICE_ID"
log "Generated DEVICE_NAME=$DEVICE_NAME"
