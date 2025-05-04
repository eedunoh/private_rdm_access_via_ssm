#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Install Docker using yum
sudo yum update -y
sudo yum install -y docker

# Start Docker service
sudo service docker start

# Enable Docker to start on boot
sudo systemctl enable docker

# Add ec2-user to Docker group
sudo usermod -aG docker ec2-user