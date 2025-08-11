#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print messages
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory
BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

print_message "Starting backup process..."

# Backup MongoDB data
print_message "Backing up MongoDB data..."
docker exec cyberguard-mongodb mongodump --out /dump
docker cp cyberguard-mongodb:/dump "$BACKUP_DIR/mongodb"
docker exec cyberguard-mongodb rm -rf /dump
print_success "MongoDB backup completed"

# Backup Wazuh data
print_message "Backing up Wazuh data..."
docker cp wazuh-manager:/var/ossec/etc "$BACKUP_DIR/wazuh_etc"
docker cp wazuh-manager:/var/ossec/logs "$BACKUP_DIR/wazuh_logs"
print_success "Wazuh backup completed"

# Backup Graylog data
print_message "Backing up Graylog configuration..."
docker cp graylog:/usr/share/graylog/data/config "$BACKUP_DIR/graylog_config"
print_success "Graylog backup completed"

# Backup TheHive data
print_message "Backing up TheHive data..."
docker cp thehive:/opt/thp/thehive/data "$BACKUP_DIR/thehive_data"
print_success "TheHive backup completed"

# Backup MISP data
print_message "Backing up MISP data..."
docker cp misp:/var/www/MISP/app/files "$BACKUP_DIR/misp_files"
print_success "MISP backup completed"

# Backup OpenCTI data
print_message "Backing up OpenCTI data..."
docker cp opencti:/opt/opencti/data "$BACKUP_DIR/opencti_data"
print_success "OpenCTI backup completed"

# Backup Velociraptor data
print_message "Backing up Velociraptor data..."
docker cp velociraptor:/opt/velociraptor/data "$BACKUP_DIR/velociraptor_data"
print_success "Velociraptor backup completed"

# Backup Shuffle data
print_message "Backing up Shuffle data..."
docker cp shuffle:/opt/shuffle/data "$BACKUP_DIR/shuffle_data"
print_success "Shuffle backup completed"

# Create archive
print_message "Creating backup archive..."
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
rm -rf "$BACKUP_DIR"
print_success "Backup archive created at $BACKUP_DIR.tar.gz"

print_message "Backup process completed successfully!"
