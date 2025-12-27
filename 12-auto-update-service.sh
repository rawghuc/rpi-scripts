#!/usr/bin/env bash
source ./00-common.sh

RUN_USER="${SUDO_USER:-}"

cat >/usr/local/bin/update_flaskserver.sh <<'EOF'
#!/usr/bin/env bash
cd /home/$RUN_USER/flaskserver
git fetch --all
git reset --hard origin/deploy-rpi
EOF
chmod +x /usr/local/bin/update_flaskserver.sh

cat >/etc/systemd/system/flask-update.service <<EOF
[Unit]
Description=Auto Update Flask Code
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update_flaskserver.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable flask-update
