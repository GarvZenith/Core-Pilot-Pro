#!/bin/bash
LOG_FILE="/var/log/core-pilot.log"
sudo touch "$LOG_FILE" && sudo chmod 666 "$LOG_FILE"

MODE=$1
echo "==========================================="
echo "   CORE PILOT PRO: SYSTEM ${MODE^^}        "
echo "==========================================="

# Force password prompt
echo "Please enter your password to authorize $MODE:"
until sudo -v; do
    echo "Password incorrect. Try again."
    sleep 1
done

if [ "$MODE" == "upgrade" ]; then
    (sudo apt update && sudo apt full-upgrade -y) 2>&1 | tee -a "$LOG_FILE"
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "\n\e[32m✔ UPGRADE SUCCESSFUL!\e[0m"
        if [ -f /var/run/reboot-required ]; then
            REBOOT_PKGS=$(cat /var/run/reboot-required.pkgs 2>/dev/null | tr '\n' ' ')
            USER_NAME=$(who | grep '(:[0-9])' | head -n 1 | awk '{print $1}')
            sudo -u "$USER_NAME" DISPLAY=:0 zenity --warning --title="Reboot Required" --text="Reboot needed for:\n\n$REBOOT_PKGS" --width=400 &
        fi
    else
        echo -e "\n\e[31m✘ UPGRADE FAILED.\e[0m"
    fi
elif [ "$MODE" == "cleanup" ]; then
    echo "[$(date)] Running autoremove..." | tee -a "$LOG_FILE"
    sudo apt autoremove -y 2>&1 | tee -a "$LOG_FILE"
    [ ${PIPESTATUS[0]} -eq 0 ] && echo -e "\n\e[32m✔ CLEANED!\e[0m" || echo -e "\n\e[31m✘ FAILED.\e[0m"
fi

echo -e "\n-------------------------------------------"
echo "Press any key to close."
read -n 1
