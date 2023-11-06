#!/bin/bash

# Step 1: Add the current user to the docker group
sudo usermod -aG docker $USER

# Step 2: Switch to the current user
su - $USER

# Step 3: Print the groups for the current user
groups

# Step 4: Manually enter the username for the next user
read -p "Enter the username to add to the docker group manually: " username
sudo usermod -aG docker $username

# Step 5: Check Docker processes
docker ps
