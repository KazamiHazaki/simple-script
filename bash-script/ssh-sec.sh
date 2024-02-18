#!/bin/bash

# Backup the original SSH server configuration file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set MaxAuthTries to 3
sudo sed -i 's/#MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
sudo systemctl restart ssh

echo "MaxAuthTries set to 3 in SSH server configuration."
