# 🛸 Core Pilot Pro v3.0

A professional system automation and maintenance suite for Kali Linux.

## 🏗️ Architecture
- **Controller (`core-pilot-pro.sh`)**: The UI handler. Bridges the root environment to the user X11 session.
- **Worker (`pilot-worker.sh`)**: The engine. Handles system updates and disk maintenance.
- **Automation**: Managed via `systemd` timers on a 4-hour cycle.

## 🛠️ Installation
\`\`\`bash
git clone https://github.com/YOUR_USERNAME/Core-Pilot-Pro.git
cd Core-Pilot-Pro
sudo ./install.sh
\`\`\`

## 📝 Human-Style Design
- **DBUS Handshake**: Manually exports session bus paths to ensure UI reliability.
- **Paranoid Logic**: Includes disk-usage checks to prevent system hangs during updates.
