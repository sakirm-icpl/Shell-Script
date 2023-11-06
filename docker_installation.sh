#!/bin/bash

# Update the package index and install required dependencies
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Print Docker and Docker Compose versions
docker --version
docker-compose --version

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Switch to the current user
su - $USER

# Print the groups for the current user
groups

#  Manually enter the username for the next user

read -p "Enter the username to add to the docker group manually: " username

sudo usermod -aG docker $username

# Step 5: Check Docker processes
docker ps

# You may need to log out and back in for group changes to take effect

echo "Docker and Docker Compose installation completed."
