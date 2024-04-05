#!/bin/bash

# Log file path
LOG_FILE="/home/ubuntu/script/backup.log"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# Load environment variables from .env file
source /home/ubuntu/script/.env

# Set the current date and time
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Set the directory where backups will be stored
BACKUP_DIR="/home/ubuntu/script"

# Backup filename
BACKUP_FILE="$BACKUP_DIR/$DB_NAME_$TIMESTAMP.sql"

# Perform the backup
log "Starting database backup..."
export PGPASSWORD="$DB_PASSWORD"
pg_dump -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"
if [ $? -eq 0 ]; then
    log "Database backup completed successfully."
else
    log "Error: Database backup failed."
    exit 1
fi

# Copy the backup file to another host using SCP
log "Copying backup file to remote host..."
scp -i /home/ubuntu/.ssh/id_rsa -P 1031 "$BACKUP_FILE" homesweet@127.0.0.1:/home/dir
if [ $? -eq 0 ]; then
    log "Backup file copied successfully to remote host."
else
    log "Error: Failed to copy backup file to remote host."
fi
