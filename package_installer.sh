#!/bin/bash

# List of packages to install
PACKAGES=("curl" "wget" "git")
LOG_FILE="package_installer.log"

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

log "Package installer script started"

# Function to install package if not already installed
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        log "Installing $1"
        sudo apt-get install -y "$1"
    else
        log "$1 is already installed"
    fi
}

# Install each package
for PACKAGE in "${PACKAGES[@]}"; do
    install_package "$PACKAGE"
done
