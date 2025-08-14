#!/bin/bash

# CyberGuard Unified SOC Installation Script for Linux
# Compatible with Ubuntu 20.04+, Debian 11+, CentOS 8+, RHEL 8+

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to detect OS
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    echo "Detected OS: $OS $VER"
}

# Function to check system requirements
check_system_requirements() {
    print_message "Checking system requirements..."
    
    # Check RAM
    RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
    if [ $RAM_GB -lt 16 ]; then
        print_warning "Only ${RAM_GB}GB RAM detected. 16GB+ is recommended"
    else
        print_success "RAM: ${RAM_GB}GB (sufficient)"
    fi
    
    # Check disk space
    DISK_GB=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
    if [ $DISK_GB -lt 100 ]; then
        print_error "Only ${DISK_GB}GB disk space available. 100GB+ required"
        exit 1
    else
        print_success "Disk space: ${DISK_GB}GB (sufficient)"
    fi
    
    # Check CPU cores
    CPU_CORES=$(nproc)
    if [ $CPU_CORES -lt 4 ]; then
        print_warning "Only ${CPU_CORES} CPU cores detected. 8+ cores recommended"
    else
        print_success "CPU cores: ${CPU_CORES} (sufficient)"
    fi
}

# Function to install prerequisites
install_prerequisites() {
    print_message "Installing prerequisites..."
    
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        apt update
        apt install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg \
            lsb-release \
            wget \
            unzip \
            git \
            htop \
            net-tools
    elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Rocky"* ]]; then
        yum update -y
        yum install -y \
            curl \
            wget \
            unzip \
            git \
            htop \
            net-tools \
            yum-utils \
            device-mapper-persistent-data \
            lvm2
    fi
    
    print_success "Prerequisites installed"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Main installation process
print_message "=== CyberGuard Unified SOC Installation ==="
detect_os
check_system_requirements
install_prerequisites

# Install Docker with latest version
install_docker() {
    print_message "Installing Docker..."
    
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
        print_success "Docker already installed: $DOCKER_VERSION"
        
        # Check if version is recent (24.x+)
        MAJOR_VERSION=$(echo $DOCKER_VERSION | cut -d'.' -f1)
        if [ $MAJOR_VERSION -lt 24 ]; then
            print_warning "Docker version is outdated. Updating..."
        else
            return 0
        fi
    fi
    
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        # Remove old versions
        apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
        
        # Add Docker GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        
        # Add Docker repository
        if [[ "$OS" == *"Ubuntu"* ]]; then
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        else
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        fi
        
        apt update
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
    elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Rocky"* ]]; then
        # Remove old versions
        yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine 2>/dev/null || true
        
        # Add Docker repository
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
    
    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    
    # Add current user to docker group (if not root)
    if [ "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER
        print_success "Added $SUDO_USER to docker group"
    fi
    
    print_success "Docker installed successfully"
}

# Install Docker Compose standalone (backup method)
install_docker_compose_standalone() {
    print_message "Installing Docker Compose standalone..."
    
    if command -v docker-compose &> /dev/null; then
        COMPOSE_VERSION=$(docker-compose --version | cut -d' ' -f4 | cut -d',' -f1)
        print_success "Docker Compose already installed: $COMPOSE_VERSION"
        
        # Check if version is recent (2.x+)
        MAJOR_VERSION=$(echo $COMPOSE_VERSION | cut -d'.' -f1)
        if [ $MAJOR_VERSION -lt 2 ]; then
            print_warning "Docker Compose version is outdated. Updating..."
        else
            return 0
        fi
    fi
    
    # Get latest version
    LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
    
    # Download and install
    curl -L "https://github.com/docker/compose/releases/download/${LATEST_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Create symlink for compatibility
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose 2>/dev/null || true
    
    print_success "Docker Compose standalone installed: $LATEST_VERSION"
}

# Check and install Docker Compose
check_docker_compose() {
    print_message "Checking Docker Compose..."
    
    # Try docker compose plugin first
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version --short)
        print_success "Docker Compose plugin installed: $COMPOSE_VERSION"
        return 0
    fi
    
    # Fallback to standalone docker-compose
    install_docker_compose_standalone
}

install_docker
check_docker_compose

# Setup system configuration
setup_system_config() {
    print_message "Configuring system settings..."
    
    # Increase vm.max_map_count for Elasticsearch
    echo "vm.max_map_count=262144" >> /etc/sysctl.conf
    sysctl -p
    
    # Increase file descriptor limits
    echo "* soft nofile 65536" >> /etc/security/limits.conf
    echo "* hard nofile 65536" >> /etc/security/limits.conf
    
    # Configure Docker daemon for better performance
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "storage-driver": "overlay2"
}
EOF
    
    systemctl restart docker
    print_success "System configuration completed"
}

# Create project structure
setup_project_structure() {
    print_message "Setting up project structure..."
    
    # Change to project directory
    cd "$(dirname "$0")/.." || exit 1
    
    # Create necessary directories with proper permissions
    mkdir -p data/{mongodb,elasticsearch,graylog,graylog_journal,wazuh,thehive,misp,misp_db,opencti,velociraptor,shuffle}
    mkdir -p logs/{backend,frontend,docker}
    mkdir -p backups
    mkdir -p ssl
    
    # Set proper permissions
    chmod -R 755 data/
    chmod -R 755 logs/
    chmod -R 755 backups/
    
    # Create log files
    touch logs/backend/app.log
    touch logs/frontend/access.log
    touch logs/docker/compose.log
    
    print_success "Project structure created"
}

# Verify and setup environment file
setup_environment() {
    print_message "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        print_error ".env file not found. Creating from template..."
        if [ -f .env.example ]; then
            cp .env.example .env
            print_success "Created .env from template"
        else
            print_error "No .env.example file found. Please create .env manually."
            exit 1
        fi
    else
        print_success ".env file found"
    fi
    
    # Validate critical environment variables
    source .env
    
    if [ -z "$GRAYLOG_PASSWORD_SECRET" ] || [ "$GRAYLOG_PASSWORD_SECRET" = "changeme_in_production" ]; then
        print_warning "Please update GRAYLOG_PASSWORD_SECRET in .env file"
    fi
    
    if [ -z "$GRAYLOG_ROOT_PASSWORD_SHA2" ] || [ "$GRAYLOG_ROOT_PASSWORD_SHA2" = "changeme" ]; then
        print_warning "Please update GRAYLOG_ROOT_PASSWORD_SHA2 in .env file"
    fi
}

# Generate SSL certificates if needed
generate_certificates() {
    print_message "Checking SSL certificates..."
    
    if [ ! -d "ssl" ]; then
        mkdir -p ssl
    fi
    
    if [ ! -f "ssl/cert.pem" ] || [ ! -f "ssl/key.pem" ]; then
        print_message "Generating self-signed SSL certificates..."
        openssl req -x509 -newkey rsa:4096 -keyout ssl/key.pem -out ssl/cert.pem -days 365 -nodes \
            -subj "/C=US/ST=State/L=City/O=CyberGuard/OU=SOC/CN=localhost"
        print_success "SSL certificates generated"
    else
        print_success "SSL certificates already exist"
    fi
}

# Build and start services
deploy_services() {
    print_message "Building Docker images..."
    
    # Use docker compose plugin if available, fallback to docker-compose
    if docker compose version &> /dev/null; then
        COMPOSE_CMD="docker compose"
    else
        COMPOSE_CMD="docker-compose"
    fi
    
    # Navigation intelligente vers le dossier docker
    if [ -d "docker" ]; then
        cd docker || exit 1
    elif [ -d "../docker" ]; then
        cd ../docker || exit 1
    else
        print_error "Dossier docker non trouvé. Vérifiez la structure du projet."
        exit 1
    fi
    
    # Pull latest base images
    $COMPOSE_CMD pull mongodb elasticsearch redis
    
    # Build custom images
    $COMPOSE_CMD build --no-cache --parallel
    
    print_success "Docker images built"
    
    print_message "Starting services in stages..."
    
    # Stage 1: Databases
    print_message "Starting databases..."
    $COMPOSE_CMD up -d mongodb elasticsearch redis misp-db
    
    # Wait for databases to be ready
    print_message "Waiting for databases to initialize..."
    sleep 60
    
    # Verify database connectivity
    for i in {1..10}; do
        if docker exec cyberguard-mongodb mongo --eval "db.adminCommand('ping')" &>/dev/null; then
            print_success "MongoDB is ready"
            break
        fi
        if [ $i -eq 10 ]; then
            print_error "MongoDB failed to start"
            exit 1
        fi
        sleep 10
    done
    
    # Stage 2: Backend services
    print_message "Starting backend services..."
    $COMPOSE_CMD up -d backend
    sleep 30
    
    # Stage 3: Frontend
    print_message "Starting frontend..."
    $COMPOSE_CMD up -d frontend
    sleep 20
    
    # Stage 4: Security tools
    print_message "Starting security tools..."
    $COMPOSE_CMD up -d wazuh-manager graylog thehive misp opencti velociraptor shuffle
    
    print_success "All services started"
    
    cd .. || exit 1
}

# Post-installation verification
verify_installation() {
    print_message "Verifying installation..."
    
    # Navigation intelligente vers le dossier docker
    if [ -d "docker" ]; then
        cd docker || exit 1
    elif [ -d "../docker" ]; then
        cd ../docker || exit 1
    else
        print_error "Dossier docker non trouvé pour la vérification."
        exit 1
    fi
    
    if docker compose version &> /dev/null; then
        COMPOSE_CMD="docker compose"
    else
        COMPOSE_CMD="docker-compose"
    fi
    
    # Check container status
    $COMPOSE_CMD ps
    
    # Test service endpoints
    sleep 30
    
    print_message "Testing service endpoints..."
    
    # Backend health check
    if curl -f http://localhost:8000/health &>/dev/null; then
        print_success "Backend API is responding"
    else
        print_warning "Backend API is not responding yet"
    fi
    
    # Frontend check
    if curl -f http://localhost:3000 &>/dev/null; then
        print_success "Frontend is responding"
    else
        print_warning "Frontend is not responding yet"
    fi
    
    cd .. || exit 1
}

# Main installation flow
setup_system_config
setup_project_structure
setup_environment
generate_certificates
deploy_services
verify_installation

# Final installation summary
print_message "=================== INSTALLATION COMPLETE ==================="
print_success "CyberGuard Unified SOC has been successfully installed!"

print_message ""
print_message "Access URLs:"
print_message "Frontend:        http://localhost:3000"
print_message "Backend API:     http://localhost:8000"
print_message "API Docs:        http://localhost:8000/docs"
print_message "Graylog:         http://localhost:9000"
print_message "TheHive:         http://localhost:9001"
print_message "MISP:            https://localhost:443"
print_message "OpenCTI:         http://localhost:8080"
print_message "Velociraptor:    http://localhost:8889"
print_message "Shuffle:         https://localhost:3443"

print_message ""
print_message "Default Credentials:"
print_message "Graylog:         admin / admin"
print_message "TheHive:         admin@thehive.local / secret"
print_message "MISP:            admin@admin.test / admin"
print_message "OpenCTI:         admin@cyberguard.local / cyberguard_admin"
print_message "Velociraptor:    admin / cyberguard_velociraptor_password"
print_message "Shuffle:         admin / cyberguard_shuffle_secret"

print_message ""
print_warning "IMPORTANT SECURITY NOTES:"
print_warning "1. Change all default passwords immediately"
print_warning "2. Update .env file with secure values"
print_warning "3. Configure SSL certificates for production"
print_warning "4. Set up firewall rules to restrict access"
print_warning "5. Review and customize security configurations"

print_message ""
print_message "Useful Commands:"
print_message "Check status:    cd docker && docker compose ps"
print_message "View logs:       cd docker && docker compose logs -f [service]"
print_message "Stop services:   cd docker && docker compose down"
print_message "Start services:  cd docker && docker compose up -d"

print_message ""
print_message "For support and documentation, visit:"
print_message "Documentation:   ./docs/"
print_message "Troubleshooting: ./docs/troubleshooting.md"

print_success "Installation completed successfully!"

# Logout message for docker group
if [ "$SUDO_USER" ]; then
    print_warning "Please log out and log back in for Docker group changes to take effect"
fi
