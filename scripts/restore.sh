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

# Check if backup file is provided
if [ -z "$1" ]; then
    print_error "No backup file specified"
    echo "Usage: $0 <backup_file.tar.gz>"
    exit 1
fi

BACKUP_FILE="$1"
TEMP_DIR="../temp_restore"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    print_error "Backup file not found: $BACKUP_FILE"
    exit 1
fi

print_message "Starting restore process..."

# Extract backup
print_message "Extracting backup archive..."
mkdir -p "$TEMP_DIR"
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
BACKUP_DIR=$(ls "$TEMP_DIR")
print_success "Backup extracted"

# Stop all services
print_message "Stopping all services..."

# Navigation intelligente vers le dossier docker
if [ -d "docker" ]; then
    cd docker || exit 1
elif [ -d "../docker" ]; then
    cd ../docker || exit 1
else
    print_error "Dossier docker non trouvé"
    exit 1
fi

docker-compose down
print_success "Services stopped"

# Restore MongoDB data
if [ -d "$TEMP_DIR/$BACKUP_DIR/mongodb" ]; then
    print_message "Restoring MongoDB data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/mongodb" cyberguard-mongodb:/dump
    docker exec cyberguard-mongodb mongorestore /dump
    docker exec cyberguard-mongodb rm -rf /dump
    print_success "MongoDB restore completed"
fi

# Restore Wazuh data
if [ -d "$TEMP_DIR/$BACKUP_DIR/wazuh_etc" ]; then
    print_message "Restoring Wazuh configuration..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/wazuh_etc" wazuh-manager:/var/ossec/
    docker cp "$TEMP_DIR/$BACKUP_DIR/wazuh_logs" wazuh-manager:/var/ossec/
    print_success "Wazuh restore completed"
fi

# Restore Graylog configuration
if [ -d "$TEMP_DIR/$BACKUP_DIR/graylog_config" ]; then
    print_message "Restoring Graylog configuration..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/graylog_config" graylog:/usr/share/graylog/data/
    print_success "Graylog restore completed"
fi

# Restore TheHive data
if [ -d "$TEMP_DIR/$BACKUP_DIR/thehive_data" ]; then
    print_message "Restoring TheHive data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/thehive_data" thehive:/opt/thp/thehive/
    print_success "TheHive restore completed"
fi

# Restore MISP data
if [ -d "$TEMP_DIR/$BACKUP_DIR/misp_files" ]; then
    print_message "Restoring MISP data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/misp_files" misp:/var/www/MISP/app/
    print_success "MISP restore completed"
fi

# Restore OpenCTI data
if [ -d "$TEMP_DIR/$BACKUP_DIR/opencti_data" ]; then
    print_message "Restoring OpenCTI data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/opencti_data" opencti:/opt/opencti/
    print_success "OpenCTI restore completed"
fi

# Restore Velociraptor data
if [ -d "$TEMP_DIR/$BACKUP_DIR/velociraptor_data" ]; then
    print_message "Restoring Velociraptor data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/velociraptor_data" velociraptor:/opt/velociraptor/
    print_success "Velociraptor restore completed"
fi

# Restore Shuffle data
if [ -d "$TEMP_DIR/$BACKUP_DIR/shuffle_data" ]; then
    print_message "Restoring Shuffle data..."
    docker cp "$TEMP_DIR/$BACKUP_DIR/shuffle_data" shuffle:/opt/shuffle/
    print_success "Shuffle restore completed"
fi

# Cleanup
print_message "Cleaning up..."
rm -rf "$TEMP_DIR"

# Start services
print_message "Starting services..."
docker-compose up -d
print_success "Services started"

# Navigation intelligente pour retourner à la position d'origine
if [ -f "../scripts/restore.sh" ]; then
    cd .. || exit 1
elif [ -f "../../scripts/restore.sh" ]; then
    cd ../.. || exit 1
fi

print_message "Restore process completed successfully!"
