#!/bin/bash

LOG_FILE="./rollback_docker.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Docker is installed..."
if command -v docker &> /dev/null; then
    log "Uninstalling Docker and Docker Compose..."
    sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>&1 | tee -a "$LOG_FILE"
    sudo rm /etc/apt/sources.list.d/docker.list 2>&1 | tee -a "$LOG_FILE"
    sudo rm /etc/apt/keyrings/docker.asc 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get autoremove -y 2>&1 | tee -a "$LOG_FILE"
    sudo rm /usr/local/bin/docker-compose 2>&1 | tee -a "$LOG_FILE"
    log "Docker and Docker Compose uninstalled successfully."
else
    log "Docker is not installed. Skipping Docker uninstallation."
fi
