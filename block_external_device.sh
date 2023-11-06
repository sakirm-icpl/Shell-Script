#!/bin/bash

# Set the path to your script file
SCRIPT_PATH="/etc/script.sh"
PLIST_PATH="/Library/LaunchAgents/com.block_device.script.plist"

# Create the Bash script
cat > $SCRIPT_PATH <<EOL
#!/bin/bash

# List all external drives
external_drives=\$(diskutil list | grep -i "external" | awk '{print \$1}')

# Unmount external drives with a sleep of 0.10 seconds between each unmount
for drive in \$external_drives
do
    diskutil unmountDisk \$drive
    sleep 0.10  # Sleep for 0.10 seconds (100 milliseconds) between unmount operations
done
EOL

# Make the script executable
chmod +x $SCRIPT_PATH

# Create the launch agent plist file
cat > $PLIST_PATH <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.block_device.script</string>
    <key>Program</key>
    <string>/bin/bash</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>StartInterval</key>
    <integer>1</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOL

# Load the launch agent
launchctl load $PLIST_PATH

# Start the launch agent
launchctl start com.block_device.script
