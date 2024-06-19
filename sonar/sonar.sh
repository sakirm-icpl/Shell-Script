#!/bin/bash

# Define the versions to install
SONARQUBE_VERSION="9.0.0.45539"
SONARSCANNER_VERSION="4.6.2.2472"

# Define the installation directories
SONARQUBE_INSTALL_DIR="/opt/sonarqube"
SONARSCANNER_INSTALL_DIR="/opt/sonarqube/bin"

# Get the current user's home directory
USER_HOME=$(eval echo ~${SUDO_USER})

# Download SonarQube
wget "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip" -P $USER_HOME

# Unzip SonarQube
sudo unzip "$USER_HOME/sonarqube-${SONARQUBE_VERSION}.zip" -d /opt
sudo mv "/opt/sonarqube-${SONARQUBE_VERSION}" "$SONARQUBE_INSTALL_DIR"

# Download SonarScanner
wget "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip" -P $USER_HOME

# Unzip SonarScanner
sudo unzip "$USER_HOME/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip" -d /opt
sudo mv "/opt/sonar-scanner-${SONARSCANNER_VERSION}-linux" "$SONARSCANNER_INSTALL_DIR/sonar-scanner"

# Create the sonarqube user and set its password
sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo chown -R sonarqube:sonarqube $SONARQUBE_INSTALL_DIR

# Switch to the sonarqube user and start SonarQube
sudo su - sonarqube -c "$SONARQUBE_INSTALL_DIR/bin/linux-x86-64/sonar.sh start"

echo "SonarQube started successfully."

# Cleanup
rm -f "$USER_HOME/sonarqube-${SONARQUBE_VERSION}.zip"
rm -f "$USER_HOME/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip"

echo "SonarQube $SONARQUBE_VERSION and SonarScanner $SONARSCANNER_VERSION have been successfully installed."
