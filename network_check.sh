#!/bin/bash

# Variables
WEBSITES=("google.com" "yahoo.com" "github.com")
LOG_FILE="network_check.log"

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

log "Network check script started"

# Function to check website availability
check_website() {
    if ping -c 1 "$1" &> /dev/null; then
        log "$1 is reachable"
    else
        log "$1 is not reachable"
    fi
}

# Check each website
for WEBSITE in "${WEBSITES[@]}"; do
    check_website "$WEBSITE"
done
