#!/usr/bin/env bash
source ./00-common.sh

RUN_USER="${SUDO_USER:-}"

cat >/usr/local/bin/update_flaskserver.sh <<'EOF'
#!/usr/bin/env bash
set -e

RUN_USER="${SUDO_USER:-root}"
APP_DIR="/home/$RUN_USER/flaskserver"
VENV_DIR="$APP_DIR/venv"

cd "$APP_DIR"

# Create venv if it does not exist
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR"
  chown -R "$RUN_USER:$RUN_USER" "$VENV_DIR"
fi

# Activate venv
source "$VENV_DIR/bin/activate"

# Update code
git fetch --all
git reset --hard origin/deploy-rpi

# Install/update dependencies inside venv
pip install --upgrade pip
pip install -r requirements.txt

deactivate
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

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable flask-update

