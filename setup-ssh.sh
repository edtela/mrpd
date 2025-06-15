#!/bin/bash

# Setup SSH for the developer user
mkdir -p /home/developer/.ssh
chmod 700 /home/developer/.ssh

# Create SSH config directory
sudo mkdir -p /run/sshd

# Generate host keys if they don't exist
sudo ssh-keygen -A

# Configure SSH to allow the developer user
sudo sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Add SSH public key if provided via environment variable
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > /home/developer/.ssh/authorized_keys
    chmod 600 /home/developer/.ssh/authorized_keys
    echo "SSH public key added for user 'developer'"
else
    echo "WARNING: No SSH_PUBLIC_KEY provided. SSH access will not be available."
    echo "To enable SSH, set SSH_PUBLIC_KEY environment variable with your public key"
fi

# Start SSH service
sudo /usr/sbin/sshd -D &