#!/bin/bash

LOG_FILE="./install_docker_compose.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Docker Compose is already installed..."
if command -v docker-compose &> /dev/null; then
    log "Docker Compose is already installed. Skipping Docker Compose installation."
else
    log "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.13.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 2>&1 | tee -a "$LOG_FILE"
    sudo chmod +x /usr/local/bin/docker-compose 2>&1 | tee -a "$LOG_FILE"
    docker-compose --version 2>&1 | tee -a "$LOG_FILE"
    log "Docker Compose installed successfully."
fi
