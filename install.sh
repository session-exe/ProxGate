#!/bin/bash

# UI Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}   ProxGate Zero - Tactical Installer        ${NC}"
echo -e "${BLUE}==============================================${NC}"

# 1. Environment Detection
USER_NAME=$(whoami)
BASE_DIR=$(pwd)
PYTHON_PATH=$(which python3)

# 2. System Dependencies
echo -e "\n${BLUE}[1/5] Installing system dependencies...${NC}"
sudo apt update
sudo apt install -y git build-essential pkg-config libreadline-dev gcc-arm-none-eabi \
libnewlib-dev qtbase5-dev libqt5serialport5-dev python3-dev python3-pip \
libusb-1.0-0-dev flashrom liblz4-dev libssl-dev libbz2-dev libjansson-dev \
network-manager python3-flask

# 3. Local Proxmark3 Compilation
echo -e "\n${BLUE}[2/5] Preparing Proxmark3 (Iceman Repository)...${NC}"
if [ ! -d "proxmark3" ]; then
    echo -e "${GREEN}[*] Cloning repository...${NC}"
    git clone https://github.com/RfidResearchGroup/proxmark3.git
else
    echo -e "[!] Folder 'proxmark3' already exists. Skipping clone."
fi

echo -e "${GREEN}[*] Starting compilation. This may take a while on RPi Zero...${NC}"
cd proxmark3
# Compiling only the client for portability and speed
make clean && make -j$(nproc) client
cd ..

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
sudo systemctl start proxgate.service

echo -e "${GREEN}[+] ProxGate service is active on port 80!${NC}"

# 5. Interactive Tactical Hotspot Configuration
echo -e "\n${BLUE}[4/5] Tactical Network Configuration${NC}"
echo -e "${RED}WARNING: Enabling the Hotspot will terminate your current SSH session!${NC}"
read -p "Do you want to enable the Wi-Fi Hotspot (Offline Mode) now? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    read -p "Set Network Name (SSID) [ProxGate_Zero]: " ssid
    ssid=${ssid:-"ProxGate_Zero"}
    read -p "Set Password (min. 8 chars) [pwned1234]: " pass
    pass=${pass:-"pwned1234"}

    echo -e "${GREEN}[*] Configuring Hotspot... SSH connection will drop now.${NC}"
    sudo nmcli device wifi hotspot ssid "$ssid" password "$pass"
    sudo nmcli connection modify Hotspot ipv4.addresses 10.42.0.1/24 ipv4.method shared
else
    echo -e "${GREEN}[*] Hotspot skipped. You can enable it later manually.${NC}"
fi

echo -e "\n${BLUE}==============================================${NC}"
echo -e "${GREEN}       INSTALLATION COMPLETED SUCCESSFULLY!  ${NC}"
echo -e "${BLUE}  Access: http://<pi_ip> or http://10.42.0.1    ${NC}"
echo -e "${BLUE}==============================================${NC}"