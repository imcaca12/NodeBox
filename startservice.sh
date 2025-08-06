#!/bin/bash

# --- Detect folder of this script ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_NAME="nodebox"

# --- Create systemd service file ---
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "Creating systemd service at $SERVICE_FILE..."

sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Auto-start NodeBox
After=network.target

[Service]
Type=simple
ExecStart=${SCRIPT_DIR}/$(basename "$0")
WorkingDirectory=${SCRIPT_DIR}
Restart=always
User=$(whoami)

[Install]
WantedBy=default.target
EOL

# --- Reload systemd and enable service ---
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling service to start on boot..."
sudo systemctl enable ${SERVICE_NAME}.service

echo "Starting service now..."
sudo systemctl start ${SERVICE_NAME}.service

echo "Done! NodeBox will now auto-start on boot."
