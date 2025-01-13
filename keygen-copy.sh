#!/bin/bash

# Check for required arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <remote_user> <remote_host>"
    exit 1
fi

# Variables
REMOTE_USER="$1"
REMOTE_HOST="$2"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# Generate SSH key pair if it doesn't exist
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "Generating a new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -q
    echo "SSH key pair generated at $SSH_KEY_PATH."
else
    echo "SSH key pair already exists at $SSH_KEY_PATH."
fi

# Copy the public key to the remote server
echo "Copying the public key to $REMOTE_USER@$REMOTE_HOST..."
ssh-copy-id -i "$SSH_KEY_PATH.pub" "$REMOTE_USER@$REMOTE_HOST"

# Verify the connection
echo "Verifying SSH connection to $REMOTE_USER@$REMOTE_HOST..."
ssh -o BatchMode=yes "$REMOTE_USER@$REMOTE_HOST" "echo 'SSH setup is successful!'"

if [[ $? -eq 0 ]]; then
    echo "SSH setup completed successfully!"
else
    echo "Failed to set up SSH. Please check your configuration."
fi
