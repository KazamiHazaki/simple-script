#!/bin/bash

# Check Node.js version
if command -v node > /dev/null 2>&1; then
  current_version=$(node -v | sed 's/v//')
  echo "Current Node.js version: $current_version"

  # Remove and clean Node.js if the version is less than 20
  if (( $(echo "$current_version < 20" | bc -l) )); then
    echo "Node.js version is less than 20. Removing current version..."
    apt-get remove -y nodejs
    apt-get autoremove -y
    apt-get clean
  else
    echo "Node.js version is 20 or higher. No need to update."
    exit 0
  fi
else
  echo "Node.js is not installed. Proceeding with installation..."
fi

# Install Node.js version 20
echo "Installing Node.js version 20..."
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs

# Verify installation
node_version=$(node -v)
echo "Node.js installed with version $node_version"

# Install rivalz-node-cli globally
echo "Installing rivalz-node-cli..."
npm i -g rivalz-node-cli

echo "Installation complete!"
