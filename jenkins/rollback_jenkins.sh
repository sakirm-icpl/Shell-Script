#!/bin/bash

LOG_FILE="./rollback_jenkins.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Jenkins is installed..."
if systemctl is-active --quiet jenkins; then
    log "Uninstalling Jenkins..."
    sudo systemctl stop jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get remove --purge -y jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo rm /etc/apt/sources.list.d/jenkins.list 2>&1 | tee -a "$LOG_FILE"
    sudo rm /usr/share/keyrings/jenkins-keyring.asc 2>&1 | tee -a "$LOG_FILE"
    sudo apt-get autoremove -y 2>&1 | tee -a "$LOG_FILE"
    log "Jenkins uninstalled successfully."
else
    log "Jenkins is not installed. Skipping Jenkins uninstallation."
fi
