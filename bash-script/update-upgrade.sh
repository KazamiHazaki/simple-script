#!/bin/bash

# Update the package lists
sudo apt update

# Upgrade the installed packages
sudo apt upgrade -y

# Remove unused packages and their dependencies
sudo apt autoremove -y

# Clear out the local repository of retrieved package files
sudo apt clean
