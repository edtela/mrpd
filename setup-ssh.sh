#!/bin/bash

echo "=== Starting SSH Setup ==="

# Setup SSH for the developer user
mkdir -p /home/developer/.ssh
chmod 700 /home/developer/.ssh

# Create SSH config directory
sudo mkdir -p /run/sshd

# Generate host keys if they don't exist
echo "Generating SSH host keys..."
sudo ssh-keygen -A

# Configure SSH to allow the developer user
echo "Configuring SSH daemon..."
sudo sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Add SSH public key if provided via environment variable
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > /home/developer/.ssh/authorized_keys
    chmod 600 /home/developer/.ssh/authorized_keys
    chown developer:developer /home/developer/.ssh/authorized_keys
    echo "✓ SSH public key added for user 'developer'"
    echo "  Key fingerprint: $(ssh-keygen -lf /home/developer/.ssh/authorized_keys)"
else
    echo "✗ WARNING: No SSH_PUBLIC_KEY provided. SSH access will not be available."
    echo "  To enable SSH, set SSH_PUBLIC_KEY environment variable with your public key"
fi

# Test SSH configuration
echo "Testing SSH configuration..."
sudo /usr/sbin/sshd -t
if [ $? -eq 0 ]; then
    echo "✓ SSH configuration is valid"
else
    echo "✗ SSH configuration test failed"
fi

# Start SSH service
echo "Starting SSH daemon..."
sudo /usr/sbin/sshd -D -e &
SSH_PID=$!
sleep 2

# Check if SSH is running
if ps -p $SSH_PID > /dev/null; then
    echo "✓ SSH daemon started successfully (PID: $SSH_PID)"
    echo "  Listening on port 22"
else
    echo "✗ Failed to start SSH daemon"
fi

echo "=== SSH Setup Complete ==="