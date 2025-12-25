#!/usr/bin/env bash
source ./00-common.sh

SERVICES=(
  alsa-utils.service bluetooth.service ModemManager.service
  avahi-daemon.service x11-common.service triggerhappy.service
  pigpiod.service rsync.service udisks2.service nfs-common.service
  rpcbind.service
)

log "Disabling unnecessary services..."
for s in "${SERVICES[@]}"; do
  systemctl disable "$s" 2>/dev/null || true
  systemctl stop "$s" 2>/dev/null || true
done
