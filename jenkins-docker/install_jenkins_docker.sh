#!/bin/bash

LOG_FILE="./install_jenkins_docker.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Checking if Jenkins container is already running..."
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^jenkins\$"; then
    log "Jenkins container is already running. Skipping Jenkins installation."
else
    log "Installing Jenkins inside Docker..."
    sudo docker pull jenkins/jenkins:lts 2>&1 | tee -a "$LOG_FILE"
    sudo mkdir -p /var/jenkins_home 2>&1 | tee -a "$LOG_FILE"
    sudo chown -R 1000:1000 /var/jenkins_home 2>&1 | tee -a "$LOG_FILE"
    sudo docker run -d \
        -p 8080:8080 -p 50000:50000 \
        --name jenkins \
        -v /var/jenkins_home:/var/jenkins_home \
        jenkins/jenkins:lts 2>&1 | tee -a "$LOG_FILE"
    log "Jenkins is now running inside Docker."
    log "Access Jenkins at http://localhost:8080"
fi
