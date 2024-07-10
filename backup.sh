#!/bin/bash

# Variables
SOURCE_DIR="/path/to/source"
BACKUP_DIR="/path/to/backup"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="backup-$TIMESTAMP.tar.gz"
LOG_FILE="backup.log"

# Logging function
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

log "Backup script started"
log "Creating backup of $SOURCE_DIR at $BACKUP_DIR/$BACKUP_FILE"
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"
log "Backup completed successfully"
