#!/bin/bash

# Update the package list and install required dependencies
sudo apt update
sudo apt install -y openjdk-8-jdk apt-transport-https ca-certificates curl software-properties-common

# Import Jenkins GPG key and add the Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list to include Jenkins and Docker
sudo apt update

# Install Jenkins, Docker, and their dependencies
sudo apt install -y jenkins docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start the Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Display the initial admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Print Docker and Docker Compose versions
docker --version
docker-compose --version

# Add your user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER

# Switch to the current user
su - $USER

# Print the groups for the current user
groups

# Manually enter the username for the next user
read -p "Enter the username to add to the docker group manually: " username

sudo usermod -aG docker $username

#  Check Docker processes
docker ps

# You may need to log out and back in for group changes to take effect

echo "Jenkins and Docker installation completed."
