#!/bin/bash

LOG_FILE="./setup_services.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

install_docker() {
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
}

install_docker_compose() {
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
}

install_jenkins_docker() {
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
}

rollback_jenkins_docker() {
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
}

rollback_docker() {
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
}

echo "Please choose the operation:"
echo "1. Install Docker, Docker Compose, and Jenkins inside Docker"
echo "2. Rollback Jenkins inside Docker"
echo "3. Rollback Docker and Docker Compose"

read -p "Enter your choice: " choice

case "$choice" in
    1)
        log "Starting installation of Docker, Docker Compose, and Jenkins inside Docker..."
        install_docker
        install_docker_compose
        install_jenkins_docker
        log "Installation of Docker, Docker Compose, and Jenkins inside Docker completed."
        ;;
    2)
        log "Starting rollback of Jenkins inside Docker..."
        rollback_jenkins_docker
        log "Rollback of Jenkins inside Docker completed."
        ;;
    3)
        log "Starting rollback of Docker and Docker Compose..."
        rollback_jenkins_docker
        rollback_docker
        log "Rollback of Docker and Docker Compose completed."
        ;;
    *)
        log "Invalid choice. Please enter 1, 2, or 3."
        ;;
esac
