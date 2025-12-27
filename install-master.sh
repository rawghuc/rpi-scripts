#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Ensure module scripts are executable
# ---------------------------
SCRIPT_DIR="$(dirname "$0")"
chmod +x "$SCRIPT_DIR"/*.sh

echo "✔ Module scripts are now executable"

# ---------------------------
# Handle arguments
# ---------------------------
# DEPLOY_KEY="${1:-}"
TAILSCALE_KEY="${2:-}"
BACKEND_URL="${3:-}"

echo "Starting Master Installer..."

./01-system-setup.sh
./02-disable-services.sh
./03-install-deploy-key.sh "pi"
./04-auto-static-ip.sh "192.168.1" "192.168.1.1" "8.8.8.8,1.1.1.1" 2 99
./05-identify-device.sh
./06-tailscale-setup.sh "$TAILSCALE_KEY"
./07-clone-project.sh "pi" "git@github.com:Innoway-Technologies-OPC-Pvt-Ltd/rpiserver.git" "new-structure-v-1-1"
./08-install-python-req.sh
./09-register-backend.sh "$BACKEND_URL"
./10-write-config.sh
./11-create-flask-service.sh
./12-auto-update-service.sh

echo "Done. Rebooting..."
reboot
