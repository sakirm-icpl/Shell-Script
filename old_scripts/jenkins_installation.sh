#!/bin/bash

# Download Jenkins GPG key to the keyring
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins apt repository entry
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update your local package index
sudo apt-get update

# Install required packages
sudo apt-get install -y fontconfig openjdk-11-jre

# Install Jenkins
sudo apt-get install -y jenkins

