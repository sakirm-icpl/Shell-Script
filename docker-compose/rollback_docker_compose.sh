#!/bin/bash

LOG_FILE="./rollback_docker_compose.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Docker Compose is installed..."
if command -v docker-compose &> /dev/null; then
    log "Uninstalling Docker Compose..."
    sudo rm /usr/local/bin/docker-compose 2>&1 | tee -a "$LOG_FILE"
    log "Docker Compose uninstalled successfully."
else
    log "Docker Compose is not installed. Skipping Docker Compose uninstallation."
fi
