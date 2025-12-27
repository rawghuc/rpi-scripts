#!/usr/bin/env bash
source ./00-common.sh

BASE="192.168.1"
GATEWAY="192.168.1.1"
DNS="8.8.8.8,1.1.1.1"
MIN=2
MAX=99

log "Applying static IP based on MAC..."

WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2=="wifi"{print $1; exit}')
# CON_NAME=$(nmcli -t -f DEVICE,CONNECTION connection show --active | awk -F: -v d="$WIFI_DEVICE" '$1==d{print $2; exit}')
# List all active connections + their devices
# Example format: "OfficeWiFi:wlan0"
CON_NAME=$(nmcli -t -f NAME,DEVICE connection show --active \
  | awk -F: -v d="$WIFI_DEVICE" '$2==d {print $1; exit}')

MAC=$(cat /sys/class/net/$WIFI_DEVICE/address)
LAST_HEX="${MAC##*:}"
LAST_DEC=$((16#$LAST_HEX))
RANGE=$((MAX - MIN + 1))
OCTET=$(( (LAST_DEC % RANGE) + MIN ))

STATIC_IP="$BASE.$OCTET/24"

log "Assigning $STATIC_IP to $CON_NAME"

nmcli connection modify "$CON_NAME" ipv4.method manual ipv4.addresses "$STATIC_IP" \
     ipv4.gateway "$GATEWAY" ipv4.dns "$DNS"

# nmcli connection down "$CON_NAME" || true # this will disconnect the rpi
# nmcli connection up "$CON_NAME"

log "Static IP applied. Will become active after reboot."
