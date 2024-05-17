#!/bin/bash


echo -e "\e[34m ::::    ::::      :::     :::    ::: :::::::::: :::::::::  ::::::::::: :::::::::  \e[0m"
echo -e "\e[34m :+:+:  :+:+:+   :+: :+:   :+:   :+:  :+:        :+:    :+:     :+:     :+:    :+: \e[0m"
echo -e "\e[34m :+: +:+:+ +:+ +:+    +:+  +:+  +:+   +:+        +:+    +:+     +:+     +:+    +:+ \e[0m"
echo -e "\e[34m +#+  +:+  +#+ +#++:++#++: +#++:++    +#++:++#   +#++:++#:      +#+     +#+    +:+ \e[0m"
echo -e "\e[34m +#+       +#+ +#+     +#+ +#+  +#+   +#+        +#+    +#+     +#+     +#+    +#+ \e[0m"
echo -e "\e[34m #+#       #+# #+#     #+# #+#   #+#  #+#        #+#    #+#     #+#     #+#    #+# \e[0m"
echo -e "\e[34m ###       ### ###     ### ###    ### ########## ###    ### ########### #########  \e[0m"

echo "https://t.me/MakerIDAirdrop"

echo "This script will create a new user, disable password for root, and add SSH key access for the new user."
read -p "Are you sure you want to continue? (yes/no): " CONFIRMATION

if [[ $CONFIRMATION != "yes" ]]; then
    echo "Exiting script."
    exit 0
fi


echo "Create New Sudo User"
echo "==========="
read -p "Enter Username :" USERNAME 
mkdir /home/$USERNAME/.ssh
read -p "Enter your public key: " PUBKEY
echo "$PUBKEY" >> /home/$USERNAME/.ssh/authorized_keys
sudo chown $USERNAME: /home/$USERNAME/.ssh
sudo chown $USERNAME: /home/$USERNAME/.ssh/authorized_keys

# Append user to sudoers
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# disable root login, disable password authentication, use ssh keys only
sudo sed -i 's|^PermitRootLogin .*|PermitRootLogin no|' /etc/ssh/sshd_config
sudo sed -i 's|^ChallengeResponseAuthentication .*|ChallengeResponseAuthentication no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PasswordAuthentication .*|PasswordAuthentication no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PermitEmptyPasswords .*|PermitEmptyPasswords no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PubkeyAuthentication .*|PubkeyAuthentication yes|' /etc/ssh/sshd_config

echo "Apply Configuration to SSHD"
sudo sshd -t 
if [ $? -ne 0 ]; then
    echo "Error in SSH configuration. aborting."
    exit 1
fi
sudo systemctl restart sshd

echo "Installing Fail2Ban"
sudo apt install -y fail2ban

read -p "Change hostname :" HOSTNAME
sudo hostnamectl set-hostname $HOSTNAME
echo "Setup Complete"
