#!/bin/bash

# Variables
LOG_FILE="/var/log/system_monitor.log"
INTERVAL=5

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

log "System monitoring script started"

# Function to log system usage
log_usage() {
    log "Logging system usage"
    echo "Timestamp: $(date +"%Y-%m-%d %H:%M:%S")" >> "$LOG_FILE"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')" >> "$LOG_FILE"
    echo "Memory Usage: $(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')" >> "$LOG_FILE"
    echo "Disk Usage: $(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')" >> "$LOG_FILE"
    echo "---------------------------------" >> "$LOG_FILE"
}

# Main loop
while true; do
    log_usage
    sleep "$INTERVAL"
done
