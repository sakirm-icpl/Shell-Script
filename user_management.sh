#!/bin/bash

# Variables
USERNAME=$1
PASSWORD=$2
GROUP=$3
LOG_FILE="user_management.log"

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

log "User management script started"

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    log "This script must be run as root"
    echo "This script must be run as root"
    exit 1
fi

# Add user
log "Adding user $USERNAME"
useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
log "User $USERNAME added and password set"

# Add user to group
log "Adding user $USERNAME to group $GROUP"
usermod -aG "$GROUP" "$USERNAME"
log "User $USERNAME added to group $GROUP"
