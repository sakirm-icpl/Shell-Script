#!/bin/bash

LOG_FILE="./rollback_jenkins_docker.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Jenkins container is running..."
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^jenkins\$"; then
    log "Uninstalling Jenkins inside Docker..."
    sudo docker stop jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo docker rm jenkins 2>&1 | tee -a "$LOG_FILE"
    sudo rm -rf /var/jenkins_home 2>&1 | tee -a "$LOG_FILE"
    log "Jenkins inside Docker has been uninstalled."
else
    log "Jenkins container is not running. Skipping Jenkins uninstallation."
fi
