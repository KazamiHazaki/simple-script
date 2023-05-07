#!/bin/bash

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y git curl zip python3 python3-pip

# Verify the installations
echo "Git version: $(git --version)"
echo "Curl version: $(curl --version)"
echo "Zip version: $(zip --version)"
echo "Python3 version: $(python3 --version)"
echo "Python3-pip version: $(pip3 --version)"
