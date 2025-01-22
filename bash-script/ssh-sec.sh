#!/bin/bash

# Backup the original SSH server configuration file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Prompt to create a new user
read -p "Do you want to create a new user? (yes/no): " create_user
if [[ $create_user == "yes" ]]; then
    read -p "Enter the new username: " username
    sudo adduser "$username"
    echo "User '$username' created successfully."
    
    # Add the user to the sudo group
    sudo usermod -aG sudo "$username"
    echo "User '$username' added to the sudo group."
fi

# Set MaxAuthTries to 3
sudo sed -i 's/#*MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

# Disable root login with password
sudo sed -i 's/#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

# Disable password authentication (encourage key-based authentication)
sudo sed -i 's/#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restrict SSH to specific users if a new user was created
if [[ $create_user == "yes" ]]; then
    sudo sed -i "/^AllowUsers/ s/$/ $username/" /etc/ssh/sshd_config || echo "AllowUsers $username" | sudo tee -a /etc/ssh/sshd_config
    echo "SSH access restricted to user '$username'."
fi

# Configure other common SSH security best practices
sudo sed -i 's/#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
sudo sed -i 's/#*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
sudo sed -i 's/#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo sed -i 's/#*ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config
sudo sed -i 's/#*ClientAliveCountMax.*/ClientAliveCountMax 2/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
sudo systemctl restart ssh

echo "SSH server configuration updated with best practices."
