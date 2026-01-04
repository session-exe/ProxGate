#!/bin/bash

# UI Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}          ProxGate --- Installer             ${NC}"
echo -e "${BLUE}==============================================${NC}"

# 1. Environment Detection
USER_NAME=$(whoami)
BASE_DIR=$(pwd)
PYTHON_PATH=$(which python3)
PM3_BINARY="$BASE_DIR/proxmark3/client/proxmark3"

# 2. System Dependencies
echo -e "\n${BLUE}[1/5] Checking system dependencies...${NC}"
sudo apt update
sudo apt install -y git build-essential pkg-config libreadline-dev gcc-arm-none-eabi \
libnewlib-dev qtbase5-dev libqt5serialport5-dev python3-dev python3-pip \
libusb-1.0-0-dev flashrom liblz4-dev libssl-dev libbz2-dev libjansson-dev \
network-manager python3-flask

# 3. Proxmark3 Repository & Compilation Check
echo -e "\n${BLUE}[2/5] Preparing Proxmark3 Software...${NC}"

# Check if folder exists
if [ ! -d "proxmark3" ]; then
    echo -e "${GREEN}[*] Cloning Iceman repository...${NC}"
    git clone https://github.com/RfidResearchGroup/proxmark3.git
else
    echo -e "${GREEN}[!] Folder 'proxmark3' already exists.${NC}"
fi

# Check if already compiled
if [ -f "$PM3_BINARY" ]; then
    echo -e "${GREEN}[!] Proxmark3 client is already compiled. Skipping build.${NC}"
else
    echo -e "${BLUE}[*] Client not found. Starting compilation (SKIPQT mode)...${NC}"
    cd proxmark3
    make clean && make -j$(nproc) client SKIPQT=1
    cd ..
    
    if [ -f "$PM3_BINARY" ]; then
        echo -e "${GREEN}[+] Compilation successful!${NC}"
    else
        echo -e "${RED}[-][ERROR] Compilation failed! Check the logs above.${NC}"
        exit 1
    fi
fi

# 4. Systemd Service Creation (Auto-boot)
echo -e "\n${BLUE}[3/5] Configuring auto-boot service...${NC}"
cat <<EOF | sudo tee /etc/systemd/system/proxgate.service
[Unit]
Description=ProxGate Web Interface
After=network.target

[Service]
ExecStart=$PYTHON_PATH $BASE_DIR/app.py
WorkingDirectory=$BASE_DIR
StandardOutput=inherit
StandardError=inherit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable proxgate.service
sudo systemctl restart proxgate.service

echo -e "${GREEN}[+] ProxGate service is active!${NC}"

# 5. Interactive Tactical Hotspot Configuration
echo -e "\n${BLUE}[4/5] Tactical Network Configuration${NC}"
echo -e "${RED}WARNING: Enabling the Hotspot will terminate your current SSH session!${NC}"
read -p "Do you want to configure/enable the Wi-Fi Hotspot now? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    read -p "Set Network Name (SSID) [ProxGate]: " ssid
    ssid=${ssid:-"ProxGate"}
    read -p "Set Password (min. 8 chars) [eugostodenestum]: " pass
    pass=${pass:-"eugostodenestum"}

    echo -e "${GREEN}[*] Configuring Hotspot... Connection will drop soon.${NC}"
    sudo nmcli device wifi hotspot ssid "$ssid" password "$pass"
    sudo nmcli connection modify Hotspot ipv4.addresses 10.42.0.1/24 ipv4.method shared
else
    echo -e "${GREEN}[*] Hotspot skipped. You can still access via local IP.${NC}"
fi

echo -e "\n${BLUE}==============================================${NC}"
echo -e "${GREEN}       PROCESS COMPLETED SUCCESSFULLY!       ${NC}"
echo -e "${BLUE}  Web UI: http://<pi-ip> or http://10.42.0.1    ${NC}"
echo -e "${BLUE}==============================================${NC}"