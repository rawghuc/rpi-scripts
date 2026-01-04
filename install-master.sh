#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Ensure module scripts are executable
# ---------------------------
SCRIPT_DIR="$(dirname "$0")"
chmod +x "$SCRIPT_DIR"/*.sh

echo "✔ Module scripts are now executable"
echo "Starting Master Installer..."

./01-system-setup.sh
echo "System setup, now disabling unwanted services..."
./02-disable-services.sh
echo "Disabled services, not installing deploy key..."
./03-install-deploy-key.sh
echo "Installed deploy key, now identifying device..."
./05-identify-device.sh
echo "Identified device, now cloning project..."
./07-clone-project.sh
echo "Cloned project, now installing python requirements..."
./08-install-python-req.sh
echo "Installed python requirements, now registering backend..."
./09-register-backend.sh
echo "Registered backend, now writing config file..."
./10-write-config.sh
echo "Written config file, now creating flask service..."
./11-create-flask-service.sh
echo "Created flask service, now adding auto update service..."
./12-auto-update-service.sh
echo "Created auto update service, now setting up tailscale..."
./06-tailscale-setup.sh
echo "Set up tailscale, now auto-assigning static ip..."
./04-auto-static-ip.sh

echo "Done. Now rebooting..."
reboot
