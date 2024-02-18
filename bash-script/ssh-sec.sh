#!/bin/bash

# Backup the original SSH configuration file
sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.bak

# Set timeout and connection attempts
sudo tee /etc/ssh/ssh_config > /dev/null << EOF
Host *
    ConnectTimeout 10
    ConnectionAttempts 3
EOF

echo "SSH configuration updated successfully."
