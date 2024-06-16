#!/bin/bash

LOG_FILE="./install_jenkins.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Jenkins is already installed and running..."
if systemctl is-active --quiet jenkins; then
    log "Jenkins is already installed and running. Skipping Jenkins installation."
else
    log "Installing Jenkins..."
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key 2>&1 | tee -a "$LOG_FILE"
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get install -y fontconfig openjdk-17-jre 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get install -y jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo systemctl start jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo systemctl enable jenkins 2>&1 | tee -a "$LOG_FILE"
    log "Jenkins installed successfully."
fi
