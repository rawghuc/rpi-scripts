#!/usr/bin/env bash
set -euo pipefail
source ./00-common.sh

DNS="8.8.8.8,1.1.1.1"
MIN=2
MAX=99

log "Applying static IP based on MAC (gateway auto-detected)..."

# ----------------------------
# Detect Wi-Fi device
# ----------------------------
WIFI_DEVICE="$(nmcli -t -f DEVICE,TYPE,STATE device status \
  | awk -F: '$2=="wifi" && $3=="connected" {print $1; exit}')"

if [ -z "$WIFI_DEVICE" ]; then
  error "No connected Wi-Fi device found"
  exit 1
fi

log "Detected Wi-Fi device: $WIFI_DEVICE"

# ----------------------------
# Detect active connection name
# ----------------------------
CON_NAME="$(nmcli -t -f NAME,DEVICE connection show --active \
  | awk -F: -v d="$WIFI_DEVICE" '$2==d {print $1; exit}')"

if [ -z "$CON_NAME" ]; then
  error "No active Wi-Fi connection profile found"
  exit 1
fi

log "Using connection profile: $CON_NAME"

# ----------------------------
# Detect gateway & subnet
# ----------------------------
GATEWAY="$(ip route | awk '/default/ {print $3; exit}')"

if [ -z "$GATEWAY" ]; then
  error "Unable to detect default gateway"
  exit 1
fi

CIDR="$(ip -o -f inet addr show "$WIFI_DEVICE" | awk '{print $4}' | cut -d/ -f2)"

if [ -z "$CIDR" ]; then
  error "Unable to detect subnet CIDR"
  exit 1
fi

BASE="$(echo "$GATEWAY" | awk -F. '{print $1"."$2"."$3}')"

log "Detected gateway: $GATEWAY"
log "Detected subnet: ${BASE}.0/${CIDR}"

# ----------------------------
# Compute deterministic host IP
# ----------------------------
MAC="$(cat /sys/class/net/${WIFI_DEVICE}/address)"
LAST_HEX="${MAC##*:}"
LAST_DEC=$((16#${LAST_HEX}))
RANGE=$((MAX - MIN + 1))
OCTET=$(( (LAST_DEC % RANGE) + MIN ))

STATIC_IP="${BASE}.${OCTET}/${CIDR}"

log "Assigning static IP: $STATIC_IP"

# ----------------------------
# Apply static IP (no reconnect!)
# ----------------------------
nmcli connection modify "$CON_NAME" \
  ipv4.method manual \
  ipv4.addresses "$STATIC_IP" \
  ipv4.gateway "$GATEWAY" \
  ipv4.dns "$DNS"

log "Static IP configured safely. Will activate after reboot."
