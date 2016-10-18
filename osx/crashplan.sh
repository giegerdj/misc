#!/bin/bash
# Connects to CrashPlan running in a FreeNAS jail and launches the desktop
# app, then reverts all the settings back to their defaults

CRASHPLAN_SERVER="192.168.1.2"
CRASHPLAN_USER="crashplan"
CRASHPLAN_SERVER_PORT="2222"
CRASHPLAN_KEY="~/.ssh/crashplan_rsa"

# Back up the current .ui_info config file, so we can revert later
sudo cp /Library/Application\ Support/CrashPlan/.ui_info /Library/Application\ Support/CrashPlan/LOCAL.ui_info

# Get token and port from the crashplan on FreeNAS
# Combine them to form a .ui_info config file
ssh -i $CRASHPLAN_KEY -p $CRASHPLAN_SERVER_PORT $CRASHPLAN_USER@$CRASHPLAN_SERVER cat /var/lib/crashplan/.ui_info > /tmp/REMOTE.ui_info
CRASHPLAN_PORT=`cat /tmp/REMOTE.ui_info | grep -oE '[0-9]{4},' | grep -oE '[0-9]{4}' | head -n 1`
CRASHPLAN_TOKEN=`cat /tmp/REMOTE.ui_info | awk -F ',' '{print $2}'`
rm  /tmp/REMOTE.ui_info

echo "PORT: $CRASHPLAN_PORT"
echo "TOKEN: $CRASHPLAN_TOKEN"

echo "4200,$CRASHPLAN_TOKEN,127.0.0.1" | sudo tee /Library/Application\ Support/CrashPlan/.ui_info > /dev/null;
echo ".ui_info updated, creating SSH tunnel..."

# Forward local port 4200 to crashplan listening port
ssh -f -N -M -S /tmp/crashplan-remote.sock -L 4200:127.0.0.1:$CRASHPLAN_PORT -i $CRASHPLAN_KEY -p $CRASHPLAN_SERVER_PORT $CRASHPLAN_USER@$CRASHPLAN_SERVER
echo "SSH tunnel established, launching CrashPlan Desktop"

# Launch the desktop app
/Applications/CrashPlan.app/Contents/MacOS/CrashPlan > /dev/null 2>&1

echo "CrashPlan Desktop closed, terminating SSH tunnel..."

# Terminate the connection using the specified socket file (-S)
ssh -S /tmp/crashplan-remote.sock -O exit $CRASHPLAN_USER@$CRASHPLAN_SERVER

echo "Restoring local CrashPlan settings..."
sudo mv /Library/Application\ Support/CrashPlan/LOCAL.ui_info /Library/Application\ Support/CrashPlan/.ui_info
