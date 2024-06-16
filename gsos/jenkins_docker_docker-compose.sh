#!/bin/bash

LOG_FILE="./jenkins_docker_docker-compose.log"

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

install_jenkins() {
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
}

rollback_jenkins() {
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
echo "1. Install Docker and Docker Compose"
echo "2. Install Jenkins"
echo "3. Rollback Jenkins"
echo "4. Rollback Docker and Docker Compose"
echo "ALL. Install all"
echo "ALL_ROLLBACK. Rollback all"

read -p "Enter your choice: " choice

case "$choice" in
    1)
        log "Starting installation of Docker and Docker Compose..."
        install_docker
        install_docker_compose
        log "Installation of Docker and Docker Compose completed."
        ;;
    2)
        log "Starting installation of Jenkins..."
        install_jenkins
        log "Installation of Jenkins completed."
        ;;
    3)
        log "Starting rollback of Jenkins..."
        rollback_jenkins
        log "Rollback of Jenkins completed."
        ;;
    4)
        log "Starting rollback of Docker and Docker Compose..."
        rollback_docker
        log "Rollback of Docker and Docker Compose completed."
        ;;
    ALL|all)
        log "Starting installation of all services..."
        install_docker
        install_docker_compose
        install_jenkins
        log "Installation of all services completed."
        ;;
    ALL_ROLLBACK|all_rollback)
        log "Starting rollback of all services..."
        rollback_jenkins
        rollback_docker
        log "Rollback of all services completed."
        ;;
    *)
        log "Invalid choice. Please enter a valid option."
        ;;
esac
