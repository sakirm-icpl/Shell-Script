#!/bin/bash

# Define the versions to install
SONARQUBE_VERSION="9.0.0.45539"
SONARSCANNER_VERSION="4.6.2.2472"

# Define the installation directories
SONARQUBE_INSTALL_DIR="/opt"
SONARSCANNER_INSTALL_DIR="/opt/sonarqube/bin"

# Create the installation directories
#sudo mkdir -p $SONARQUBE_INSTALL_DIR
#sudo mkdir -p $SONARSCANNER_INSTALL_DIR

# Download SonarQube
wget "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"

# Unzip SonarQube
sudo unzip "/home/ubuntu/sonarqube-${SONARQUBE_VERSION}.zip" -d $SONARQUBE_INSTALL_DIR
sudo mv "$SONARQUBE_INSTALL_DIR/sonarqube-${SONARQUBE_VERSION}" "$SONARQUBE_INSTALL_DIR/sonarqube"

# Download SonarScanner
wget "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip"

# Unzip SonarScanner
sudo unzip "/home/ubuntu/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip" -d $SONARSCANNER_INSTALL_DIR
sudo mv "$SONARSCANNER_INSTALL_DIR/sonar-scanner-${SONARSCANNER_VERSION}-linux" "$SONARSCANNER_INSTALL_DIR/sonar-scanner"

# Create a system service for SonarQube
cat <<EOF | sudo tee /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=$SONARQUBE_INSTALL_DIR/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=$SONARQUBE_INSTALL_DIR/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Create the sonarqube user and set its password
sudo adduser sonar
sudo chown -R sonar:sonar /opt/sonarqube

# Switch to the sonarqube user and start SonarQube
#sudo su - sonarqube -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"

#echo "SonarQube started successfully."


# Reload systemd
sudo systemctl daemon-reload

# Start and enable the SonarQube service
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# Add the SonarScanner bin directory to the PATH
echo "export PATH=\$PATH:$SONARSCANNER_INSTALL_DIR/sonar-scanner/bin" | sudo tee -a /etc/profile

# Make the changes to the PATH effective
source /etc/profile

# Open the required port (default is 9000) in the firewall
sudo ufw allow 9000/tcp

# Adjust system limits to prevent issues with SonarQube
cat <<EOF | sudo tee /etc/security/limits.d/sonarqube.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOF

# Reload system limits
sudo systemctl restart systemd-logind

# Cleanup
rm -f /home/ubuntu/sonarqube-${SONARQUBE_VERSION}.zip
rm -f /home/ubuntu/sonar-scanner-cli-${SONARSCANNER_VERSION}-linux.zip

echo "SonarQube $SONARQUBE_VERSION and SonarScanner $SONARSCANNER_VERSION have been successfully installed."
