#!/bin/bash

# Install gnupg2
sudo apt-get install gnupg2 -y

# Add JFrog GPG key
wget -qO - https://releases.jfrog.io/artifactory/api/gpg/key/public | sudo apt-key add -

# Add JFrog repository to sources.list
echo "deb https://jfrog.bintray.com/artifactory-debs bionic main" | sudo tee /etc/apt/sources.list.d/jfrog.list

# Update package list
sudo apt-get update -y

# Install JFrog Artifactory OSS
sudo apt-get install jfrog-artifactory-oss -y

# Start Artifactory service
sudo systemctl start artifactory

# Enable Artifactory to start on boot
sudo systemctl enable artifactory

# Check the status of Artifactory service
systemctl status artifactory
