#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print messages
print_message() {
    echo -e "${BLUE}[CyberGuard]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Check system requirements
print_message "Checking system requirements..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

print_success "System requirements checked"

# Create necessary directories
print_message "Creating necessary directories..."
mkdir -p data/{mongodb,elasticsearch,graylog,graylog_journal,wazuh,thehive,misp,opencti,velociraptor,shuffle}
chmod -R 777 data/
print_success "Directories created"

# Verify .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found. Please create it from the template."
    exit 1
fi

# Generate necessary certificates and keys
print_message "Generating certificates and keys..."
./scripts/generate_certs.sh
print_success "Certificates and keys generated"

# Pull and build Docker images
print_message "Building Docker images..."
docker-compose build
print_success "Docker images built"

# Start the services
print_message "Starting CyberGuard services..."
print_message "Starting databases first..."
docker-compose up -d mongodb elasticsearch redis
sleep 30

print_message "Starting main services..."
docker-compose up -d
print_success "Services started"

# Wait for services to be ready
print_message "Waiting for services to be ready..."
sleep 30

# Configure initial settings
print_message "Configuring initial settings..."
./scripts/configure.sh
print_success "Initial configuration completed"

print_message "Installation complete! Access the dashboard at http://localhost:3000"
print_message "Default credentials:"
print_message "Username: admin"
print_message "Password: cyberguard"
