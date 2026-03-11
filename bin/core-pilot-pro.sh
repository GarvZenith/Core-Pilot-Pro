#!/bin/bash

# 1. Identity & Session Discovery
USER_NAME=$(who | grep '(:[0-9])' | head -n 1 | awk '{print $1}')
USER_ID=$(id -u "$USER_NAME")
export DISPLAY=:0
export XAUTHORITY="/home/$USER_NAME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# 2. THE CRITICAL FIX: Force desktop permissions
# This allows the background service to talk to your monitor
/usr/bin/xhost +local:root > /dev/null 2>&1

# 3. Audio Alert (Ignore errors if sound server is busy)
/usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 /usr/bin/paplay /usr/share/sounds/freedesktop/stereo/message.oga > /dev/null 2>&1 &

# 4. Interactive Menu
CHOICE=$(/usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 XAUTHORITY="$XAUTHORITY" /usr/bin/zenity --list \
    --title="Core Pilot Pro" \
    --text="System management options:" \
    --column="Action" --column="Description" \
    "Upgrade Now" "Start full system upgrade" \
    "Clean Up" "Remove unnecessary orphaned packages" \
    "10 Minutes" "Remind me in 10 minutes" \
    "Skip" "Wait 4 hours" \
    --timeout=60 --width=450 --height=350)

# 5. Handle Choice
case "$CHOICE" in
    "Upgrade Now")
        /usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 /usr/bin/notify-send 'Core Pilot' 'Launching Upgrade...'
        /usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 XAUTHORITY="$XAUTHORITY" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        /usr/bin/xfce4-terminal --title="Core Pilot: FULL UPGRADE" --hold --command="/usr/local/bin/pilot-worker.sh upgrade" &
        ;;
    "Clean Up")
        /usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 /usr/bin/notify-send 'Core Pilot' 'Starting System Clean Up...'
        /usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 XAUTHORITY="$XAUTHORITY" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        /usr/bin/xfce4-terminal --title="Core Pilot: SYSTEM CLEAN" --hold --command="/usr/local/bin/pilot-worker.sh cleanup" &
        ;;
    "10 Minutes")
        (sleep 600 && /usr/bin/systemctl start core-pilot.service) &
        ;;
    *)
        /usr/bin/sudo -u "$USER_NAME" DISPLAY=:0 /usr/bin/notify-send 'Core Pilot' 'Postponed.'
        ;;
esac
