#!/bin/bash
# ==========================================
# Core Pilot Pro - Official Installer
# Maintainer: Zenith
# ==========================================

# 1. Paranoid Root Check
if [[ $EUID -ne 0 ]]; then
   echo "[!] Error: Run this as root (sudo ./install.sh)" 
   exit 1
fi

echo "[+] Deploying Core Pilot Pro v3.0..."

# 2. Deploy Binaries
cp bin/*.sh /usr/local/bin/
chmod +x /usr/local/bin/core-pilot-pro.sh /usr/local/bin/pilot-worker.sh

# 3. Deploy Systemd Units
cp systemd/core-pilot.* /etc/systemd/system/

# 4. Reload Daemons & Enable Timer
systemctl daemon-reload
systemctl enable --now core-pilot.timer

echo "[SUCCESS] Core Pilot Pro is now active and scheduled."
