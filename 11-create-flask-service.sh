#!/usr/bin/env bash
set -euo pipefail
source ./00-common.sh

RUN_USER="$1"

log "Creating flaskserver service for user: $RUN_USER"

cat >/etc/systemd/system/flaskserver.service <<EOF
[Unit]
Description=Innoway Flask Server
After=network.target

[Service]
Environment="PYTHONUNBUFFERED=1"
WorkingDirectory=/home/${RUN_USER}/flaskserver
ExecStart=/usr/bin/python3 /home/${RUN_USER}/flaskserver/app.py --host=0.0.0.0
Restart=always
RestartSec=5
User=${RUN_USER}
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

log "Reloading systemd and starting flaskserver"

systemctl daemon-reload
systemctl enable flaskserver
systemctl restart flaskserver

log "flaskserver service created and started successfully."
