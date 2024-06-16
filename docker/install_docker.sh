#!/bin/bash

LOG_FILE="./install_docker.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Docker is already installed..."
if command -v docker &> /dev/null; then
    log "Docker is already installed. Skipping Docker installation."
else
    log "Installing Docker..."
    sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get install -y ca-certificates curl 2>&1 | tee -a "$LOG_FILE"
    sudo install -m 0755 -d /etc/apt/keyrings 2>&1 | tee -a "$LOG_FILE"
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 2>&1 | tee -a "$LOG_FILE"
    sudo chmod a+r /etc/apt/keyrings/docker.asc 2>&1 | tee -a "$LOG_FILE"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>&1 | tee -a "$LOG_FILE"
    sudo systemctl start docker 2>&1 | tee -a "$LOG_FILE"
    sudo systemctl enable docker 2>&1 | tee -a "$LOG_FILE"
    log "Docker installed successfully."
fi
