# Docker Installation and Rollback Scripts

This repository contains scripts to install and uninstall Docker and Docker Compose on a Linux system.

## Prerequisites

- Linux-based operating system (Ubuntu)
- curl
- sudo privileges

## Installation Script

The `install_docker.sh` script performs the following steps:
1. Checks if Docker is already installed.
2. If not installed, updates the package list and installs required dependencies.
3. Adds the Docker GPG key and Docker repository.
4. Installs Docker and Docker Compose.
5. Starts and enables the Docker service.
6. Logs the entire process to `install_docker.log`.

### Usage

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/your-username/docker-scripts.git
    cd docker-scripts
    ```

2. Make the installation script executable:
    ```sh
    chmod +x install_docker.sh
    ```

3. Run the script with sudo privileges:
    ```sh
    sudo ./install_docker.sh
    ```

### Log File

The script generates a log file named `install_docker.log` in the current directory, containing details of the installation process.

## Rollback Script

The `rollback_docker.sh` script performs the following steps:
1. Checks if Docker is installed.
2. If installed, removes Docker and Docker Compose, purges the packages, and removes related configuration files.
3. Logs the entire process to `rollback_docker.log`.

### Usage

1. Make the rollback script executable:
    ```sh
    chmod +x rollback_docker.sh
    ```

2. Run the script with sudo privileges:
    ```sh
    sudo ./rollback_docker.sh
    ```

### Log File

The script generates a log file named `rollback_docker.log` in the current directory, containing details of the rollback process.

