#!/bin/bash

# Check for required arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <remote_user> <remote_host>"
    exit 1
fi

# Variables for remote user and host
REMOTE_USER="$1"
REMOTE_HOST="$2"
SSH_KEY_PATH="/tmp/semaphore/.ssh/id_rsa"

# Ensure the .ssh directory exists
SSH_DIR=$(dirname "$SSH_KEY_PATH")
if [[ ! -d "$SSH_DIR" ]]; then
    echo "Creating directory $SSH_DIR..."
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Generate SSH key pair non-interactively if it doesn't exist
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "Generating a new SSH key pair non-interactively..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -q <<< y > /dev/null 2>&1
    echo "SSH key pair generated at $SSH_KEY_PATH."
else
    echo "SSH key pair already exists at $SSH_KEY_PATH."
fi

# Copy the public key to the remote server
if [[ -f "$SSH_KEY_PATH.pub" ]]; then
    echo "Copying the public key to $REMOTE_USER@$REMOTE_HOST..."
    ssh-copy-id -i "$SSH_KEY_PATH.pub" "$REMOTE_USER@$REMOTE_HOST"
else
    echo "Error: Public key file $SSH_KEY_PATH.pub not found!"
    exit 1
fi

# Verify the connection
echo "Verifying SSH connection to $REMOTE_USER@$REMOTE_HOST..."
ssh -o BatchMode=yes "$REMOTE_USER@$REMOTE_HOST" "echo 'SSH setup is successful!'"

if [[ $? -eq 0 ]]; then
    echo "SSH setup completed successfully!"
else
    echo "Failed to set up SSH. Please check your configuration."
fi
