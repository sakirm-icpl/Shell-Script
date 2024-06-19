# SonarQube Installation Script

This repository contains a script to install SonarQube and SonarScanner on a Linux system.

## Prerequisites

- Linux-based operating system (Ubuntu, CentOS, etc.)
- wget
- unzip
- sudo privileges

## Installation

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/your-username/sonarqube-installation-script.git
    cd sonarqube-installation-script
    ```

2. Make the installation script executable:
    ```sh
    chmod +x install_sonarqube.sh
    ```

3. Run the script with sudo privileges:
    ```sh
    sudo ./install_sonarqube.sh
    ```

## Script Details

The script performs the following steps:

1. Defines the versions of SonarQube and SonarScanner to install.
2. Defines the installation directories.
3. Dynamically retrieves the home directory of the user running the script.
4. Downloads the SonarQube and SonarScanner binaries.
5. Unzips the binaries to the specified installation directories.
6. Creates a system user `sonarqube` and sets the appropriate permissions.
7. Starts the SonarQube service.
8. Cleans up the downloaded zip files.

## Notes

- Ensure you have sufficient permissions to run the script and install software on your system.
- This script is intended for a fresh installation. If you have an existing SonarQube installation, please back up your data before running the script.
