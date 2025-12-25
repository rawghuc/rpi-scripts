#!/usr/bin/env bash
set -euo pipefail

LOGFILE="/var/log/rpi_installer.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Colors
GREEN="\e[32m"; RED="\e[31m"; YELLOW="\e[33m"; NC="\e[0m"

log() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

get_serial() {
  awk -F': ' '/Serial/ {print $2}' /proc/cpuinfo 2>/dev/null || hostname
}

get_short_serial() {
  local full=$(get_serial)
  echo "${full: -6}"
}

pause() { sleep 1; }
