#!/bin/bash

# Set the paths to your script file and plist file
SCRIPT_PATH="/etc/script.sh"
PLIST_PATH="/Library/LaunchAgents/com.block_device.script.plist"

# Unload the launch agent
launchctl unload $PLIST_PATH

# Delete the script file and plist file
rm $SCRIPT_PATH
rm $PLIST_PATH

# Inform the user
echo "Reverted changes: Deleted the script and plist files, and unloaded 
the launch agent."