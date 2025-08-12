#!/bin/bash

# CyberGuard Unified SOC Health Check Script for Linux
# This script validates the installation and checks service health

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print messages
print_message() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓ PASS]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗ FAIL]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠ WARN]${NC} $1"
}

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Function to increment counters
increment_total() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

increment_passed() {
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
    increment_total
}

increment_failed() {
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    increment_total
}

increment_warning() {
    WARNING_CHECKS=$((WARNING_CHECKS + 1))
    increment_total
}

# Function to test HTTP endpoint
test_http_endpoint() {
    local service_name="$1"
    local url="$2"
    local expected_status="$3"
    local timeout="${4:-10}"
    
    if curl -s -o /dev/null -w "%{http_code}" --max-time "$timeout" "$url" | grep -q "$expected_status"; then
        print_success "$service_name is responding correctly"
        increment_passed
        return 0
    else
        print_error "$service_name is not responding (URL: $url)"
        increment_failed
        return 1
    fi
}

# Function to check Docker service
check_docker_service() {
    local service_name="$1"
    local container_name="$2"
    
    if docker ps --filter "name=$container_name" --filter "status=running" --format "table {{.Names}}" | grep -q "$container_name"; then
        print_success "$service_name container is running"
        increment_passed
        return 0
    else
        print_error "$service_name container is not running or not found"
        increment_failed
        return 1
    fi
}

# Main validation script
echo "==========================================="
echo "CyberGuard Unified SOC Health Check"
echo "==========================================="
echo ""

# Change to docker directory
if [ -d "docker" ]; then
    cd docker
elif [ -d "../docker" ]; then
    cd ../docker
else
    print_error "Docker directory not found. Please run from project root."
    exit 1
fi

# Determine compose command
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

print_message "Using compose command: $COMPOSE_CMD"

# Check 1: Docker and Docker Compose
print_message "Checking Docker installation..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    print_success "Docker is installed: $DOCKER_VERSION"
    increment_passed
else
    print_error "Docker is not installed"
    increment_failed
fi

if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version --short)
        print_success "Docker Compose plugin is installed: $COMPOSE_VERSION"
    else
        COMPOSE_VERSION=$(docker-compose --version | cut -d' ' -f4 | cut -d',' -f1)
        print_success "Docker Compose standalone is installed: $COMPOSE_VERSION"
    fi
    increment_passed
else
    print_error "Docker Compose is not installed"
    increment_failed
fi

# Check 2: System resources
print_message "Checking system resources..."

# Memory check
RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
if [ $RAM_GB -ge 16 ]; then
    print_success "RAM: ${RAM_GB}GB (sufficient)"
    increment_passed
elif [ $RAM_GB -ge 8 ]; then
    print_warning "RAM: ${RAM_GB}GB (minimum met, 16GB+ recommended)"
    increment_warning
else
    print_error "RAM: ${RAM_GB}GB (insufficient, 16GB+ required)"
    increment_failed
fi

# Disk space check
DISK_GB=$(df -BG . | awk 'NR==2{print $4}' | sed 's/G//')
if [ $DISK_GB -ge 100 ]; then
    print_success "Disk space: ${DISK_GB}GB available (sufficient)"
    increment_passed
elif [ $DISK_GB -ge 50 ]; then
    print_warning "Disk space: ${DISK_GB}GB available (low, 100GB+ recommended)"
    increment_warning
else
    print_error "Disk space: ${DISK_GB}GB available (insufficient, 100GB+ required)"
    increment_failed
fi

# Check 3: Container status
print_message "Checking container status..."

# Database containers
check_docker_service "MongoDB" "cyberguard-mongodb"
check_docker_service "Elasticsearch" "cyberguard-elasticsearch" 
check_docker_service "Redis" "cyberguard-redis"
check_docker_service "MySQL (MISP)" "misp-db"

# Application containers
check_docker_service "Backend API" "cyberguard-backend"
check_docker_service "Frontend" "cyberguard-frontend"

# Security tool containers
check_docker_service "Wazuh Manager" "wazuh-manager"
check_docker_service "Graylog" "cyberguard-graylog"
check_docker_service "TheHive" "thehive"
check_docker_service "MISP" "misp"
check_docker_service "OpenCTI" "cyberguard-opencti"
check_docker_service "Velociraptor" "velociraptor"
check_docker_service "Shuffle" "shuffle"

# Check 4: Service endpoints
print_message "Testing service endpoints..."

# Give services time to fully start
sleep 5

# Core services
test_http_endpoint "Backend API Health" "http://localhost:8000/health" "200"
test_http_endpoint "Frontend" "http://localhost:3000" "200"
test_http_endpoint "Backend API Docs" "http://localhost:8000/docs" "200"

# Infrastructure services
test_http_endpoint "Elasticsearch" "http://localhost:9200" "200"
test_http_endpoint "MongoDB" "http://localhost:27017" "200" 5  # MongoDB may return different codes

# Security tools
test_http_endpoint "Graylog" "http://localhost:9000" "200"
test_http_endpoint "TheHive" "http://localhost:9001" "200"
test_http_endpoint "OpenCTI" "http://localhost:8080" "200"
test_http_endpoint "Velociraptor" "http://localhost:8889" "200"
test_http_endpoint "Wazuh API" "http://localhost:55000" "200"

# HTTPS services (may have cert issues, so check with -k)
if curl -k -s -o /dev/null -w "%{http_code}" --max-time 10 "https://localhost:443" | grep -E "200|302|401"; then
    print_success "MISP HTTPS is responding"
    increment_passed
else
    print_warning "MISP HTTPS is not responding (may still be starting)"
    increment_warning
fi

if curl -k -s -o /dev/null -w "%{http_code}" --max-time 10 "https://localhost:3443" | grep -E "200|302|401"; then
    print_success "Shuffle HTTPS is responding"
    increment_passed
else
    print_warning "Shuffle HTTPS is not responding (may still be starting)"
    increment_warning
fi

# Check 5: Port availability
print_message "Checking port availability..."

PORTS="3000 8000 9000 9001 8080 8889 443 3443 27017 9200 6379 3306 55000 1514"
for port in $PORTS; do
    if netstat -tuln | grep -q ":$port "; then
        print_success "Port $port is in use (service likely running)"
        increment_passed
    else
        print_warning "Port $port is not in use (service may not be running)"
        increment_warning
    fi
done

# Check 6: Log analysis
print_message "Analyzing container logs for errors..."

ERROR_COUNT=0
for service in backend frontend mongodb elasticsearch redis graylog thehive misp opencti; do
    if $COMPOSE_CMD logs --tail=50 $service 2>/dev/null | grep -i -E "error|exception|fatal|fail" | grep -v -E "warning|info|debug" >/dev/null; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
        print_warning "Found errors in $service logs"
        increment_warning
    fi
done

if [ $ERROR_COUNT -eq 0 ]; then
    print_success "No critical errors found in recent logs"
    increment_passed
fi

# Check 7: Volume mounts
print_message "Checking volume mounts..."

if [ -d "../data" ]; then
    DATA_SIZE=$(du -sh ../data 2>/dev/null | cut -f1)
    print_success "Data directory exists: ../data ($DATA_SIZE)"
    increment_passed
else
    print_error "Data directory not found: ../data"
    increment_failed
fi

# Final summary
echo ""
echo "==========================================="
echo "HEALTH CHECK SUMMARY"
echo "==========================================="
echo "Total checks performed: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
echo -e "${YELLOW}Warnings: $WARNING_CHECKS${NC}"
echo -e "${RED}Failed: $FAILED_CHECKS${NC}"

# Calculate overall health percentage
if [ $TOTAL_CHECKS -gt 0 ]; then
    HEALTH_PERCENTAGE=$(( (PASSED_CHECKS * 100) / TOTAL_CHECKS ))
    echo "Overall health: ${HEALTH_PERCENTAGE}%"
else
    HEALTH_PERCENTAGE=0
fi

echo ""
echo "Access URLs:"
echo "─────────────────────────────────────────"
echo "Frontend:        http://localhost:3000"
echo "Backend API:     http://localhost:8000"
echo "API Docs:        http://localhost:8000/docs"
echo "Graylog:         http://localhost:9000 (admin/admin)"
echo "TheHive:         http://localhost:9001"
echo "MISP:            https://localhost:443"
echo "OpenCTI:         http://localhost:8080"
echo "Velociraptor:    http://localhost:8889"
echo "Shuffle:         https://localhost:3443"

echo ""
echo "Useful Commands:"
echo "─────────────────────────────────────────"
echo "View all containers:   $COMPOSE_CMD ps"
echo "View logs:            $COMPOSE_CMD logs -f [service]"
echo "Restart service:      $COMPOSE_CMD restart [service]"
echo "Stop all:             $COMPOSE_CMD down"
echo "Start all:            $COMPOSE_CMD up -d"

if [ $FAILED_CHECKS -gt 0 ]; then
    echo ""
    print_error "Some critical checks failed. Please review the errors above."
    exit 1
elif [ $WARNING_CHECKS -gt 0 ]; then
    echo ""
    print_warning "Some checks have warnings. System is functional but may need attention."
    exit 0
else
    echo ""
    print_success "All checks passed! CyberGuard Unified SOC is healthy."
    exit 0
fi
