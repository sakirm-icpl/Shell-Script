# Docker Compose Installation and Rollback Scripts

This repository contains scripts to install and uninstall Docker Compose on a Linux system.

## Prerequisites

- Linux-based operating system (Ubuntu, CentOS, etc.)
- curl
- sudo privileges

## Installation Script

The `install_docker_compose.sh` script performs the following steps:
1. Checks if Docker Compose is already installed.
2. If not installed, downloads and installs Docker Compose.
3. Logs the entire process to `install_docker_compose.log`.

### Usage

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/your-username/docker-compose-scripts.git
    cd docker-compose-scripts
    ```

2. Make the installation script executable:
    ```sh
    chmod +x install_docker_compose.sh
    ```

3. Run the script with sudo privileges:
    ```sh
    sudo ./install_docker_compose.sh
    ```

### Log File

The script generates a log file named `install_docker_compose.log` in the current directory, containing details of the installation process.

## Rollback Script

The `rollback_docker_compose.sh` script performs the following steps:
1. Checks if Docker Compose is installed.
2. If installed, uninstalls Docker Compose.
3. Logs the entire process to `rollback_docker_compose.log`.

### Usage

1. Make the rollback script executable:
    ```sh
    chmod +x rollback_docker_compose.sh
    ```

2. Run the script with sudo privileges:
    ```sh
    sudo ./rollback_docker_compose.sh
    ```

### Log File

The script generates a log file named `rollback_docker_compose.log` in the current directory, containing details of the rollback process.
