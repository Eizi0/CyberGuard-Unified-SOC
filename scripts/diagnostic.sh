#!/bin/bash

# CyberGuard Unified SOC System Diagnostic Script
# Generates comprehensive system and service diagnostic information

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..60})"
}

print_section() {
    echo ""
    echo -e "${YELLOW}$1${NC}"
    echo "$(printf '-%.0s' {1..40})"
}

# Create diagnostic report
REPORT_FILE="cyberguard-diagnostic-$(date +%Y%m%d_%H%M%S).txt"

{
    print_header "CyberGuard Unified SOC - System Diagnostic Report"
    echo "Generated on: $(date)"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo ""

    print_section "SYSTEM INFORMATION"
    echo "OS Information:"
    if [ -f /etc/os-release ]; then
        cat /etc/os-release
    else
        uname -a
    fi
    echo ""
    
    echo "Kernel Version:"
    uname -r
    echo ""
    
    echo "System Uptime:"
    uptime
    echo ""

    print_section "HARDWARE RESOURCES"
    echo "CPU Information:"
    lscpu | head -20
    echo ""
    
    echo "Memory Information:"
    free -h
    echo ""
    
    echo "Disk Usage:"
    df -h
    echo ""
    
    echo "Disk I/O Statistics:"
    iostat 2>/dev/null || echo "iostat not available"
    echo ""

    print_section "NETWORK CONFIGURATION"
    echo "Network Interfaces:"
    ip addr show 2>/dev/null || ifconfig
    echo ""
    
    echo "Active Network Connections:"
    netstat -tuln | head -20
    echo ""
    
    echo "Routing Table:"
    ip route 2>/dev/null || route -n
    echo ""

    print_section "DOCKER INFORMATION"
    echo "Docker Version:"
    docker --version 2>/dev/null || echo "Docker not available"
    echo ""
    
    echo "Docker System Information:"
    docker system info 2>/dev/null || echo "Docker daemon not running"
    echo ""
    
    echo "Docker Compose Version:"
    if docker compose version &> /dev/null; then
        docker compose version
    elif command -v docker-compose &> /dev/null; then
        docker-compose --version
    else
        echo "Docker Compose not available"
    fi
    echo ""

    print_section "CONTAINER STATUS"
    if [ -d "docker" ]; then
        cd docker
    elif [ -d "../docker" ]; then
        cd ../docker
    fi
    
    # Determine compose command
    if docker compose version &> /dev/null; then
        COMPOSE_CMD="docker compose"
    else
        COMPOSE_CMD="docker-compose"
    fi
    
    echo "Container Status:"
    $COMPOSE_CMD ps 2>/dev/null || echo "Unable to get container status"
    echo ""
    
    echo "Docker Images:"
    docker images | grep -E "(cyberguard|wazuh|graylog|thehive|misp|opencti|velociraptor|shuffle)" 2>/dev/null || echo "No project images found"
    echo ""
    
    echo "Docker Networks:"
    docker network ls | grep -E "(cyberguard|docker)" 2>/dev/null || echo "No project networks found"
    echo ""
    
    echo "Docker Volumes:"
    docker volume ls | grep -E "(cyberguard|docker)" 2>/dev/null || echo "No project volumes found"
    echo ""

    print_section "RESOURCE USAGE"
    echo "Container Resource Usage:"
    docker stats --no-stream 2>/dev/null || echo "Unable to get container stats"
    echo ""
    
    echo "System Load:"
    cat /proc/loadavg 2>/dev/null || echo "Load average not available"
    echo ""
    
    echo "Process List (top 20):"
    ps aux --sort=-%cpu | head -20
    echo ""

    print_section "SERVICE LOGS (LAST 50 LINES)"
    for service in backend frontend mongodb elasticsearch redis graylog thehive misp opencti wazuh-manager velociraptor shuffle; do
        echo "=== $service logs ==="
        $COMPOSE_CMD logs --tail=50 $service 2>/dev/null || echo "No logs available for $service"
        echo ""
    done

    print_section "SYSTEM LOGS"
    echo "Recent System Messages:"
    tail -50 /var/log/syslog 2>/dev/null || tail -50 /var/log/messages 2>/dev/null || echo "System logs not accessible"
    echo ""
    
    echo "Docker Daemon Logs:"
    journalctl -u docker --no-pager -n 50 2>/dev/null || echo "Docker logs not accessible"
    echo ""

    print_section "CONFIGURATION FILES"
    echo "Environment Variables (.env):"
    if [ -f "../.env" ]; then
        # Mask sensitive values
        sed 's/=.*/=***MASKED***/g' ../.env
    else
        echo ".env file not found"
    fi
    echo ""
    
    echo "Docker Compose Configuration:"
    if [ -f "docker-compose.yml" ]; then
        head -50 docker-compose.yml
        echo "... (truncated)"
    else
        echo "docker-compose.yml not found"
    fi
    echo ""

    print_section "SECURITY CHECKS"
    echo "Open Ports:"
    netstat -tuln | grep -E ":300[0-9]|:800[0-9]|:900[0-9]|:443|:344[0-9]"
    echo ""
    
    echo "File Permissions (data directory):"
    if [ -d "../data" ]; then
        ls -la ../data/ | head -10
    else
        echo "Data directory not found"
    fi
    echo ""
    
    echo "SSL Certificates:"
    if [ -d "../ssl" ]; then
        ls -la ../ssl/
        if [ -f "../ssl/cert.pem" ]; then
            openssl x509 -in ../ssl/cert.pem -text -noout | grep -E "(Subject|Issuer|Not Before|Not After)" 2>/dev/null || echo "Certificate info not readable"
        fi
    else
        echo "SSL directory not found"
    fi
    echo ""

    print_section "CONNECTIVITY TESTS"
    echo "Service Connectivity Tests:"
    
    services=(
        "Frontend:http://localhost:3000"
        "Backend:http://localhost:8000"
        "Graylog:http://localhost:9000"
        "TheHive:http://localhost:9001"
        "OpenCTI:http://localhost:8080"
        "Velociraptor:http://localhost:8889"
        "Elasticsearch:http://localhost:9200"
    )
    
    for service_url in "${services[@]}"; do
        service_name="${service_url%%:*}"
        url="${service_url#*:}"
        
        if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" | grep -q "200"; then
            echo "✓ $service_name: OK"
        else
            echo "✗ $service_name: FAILED"
        fi
    done
    echo ""

    print_section "TROUBLESHOOTING RECOMMENDATIONS"
    echo "Common Issues and Solutions:"
    echo ""
    echo "1. If containers are not starting:"
    echo "   - Check available disk space (df -h)"
    echo "   - Check memory usage (free -h)"
    echo "   - Review container logs ($COMPOSE_CMD logs [service])"
    echo ""
    echo "2. If services are not accessible:"
    echo "   - Verify ports are not blocked (netstat -tuln)"
    echo "   - Check firewall settings"
    echo "   - Ensure containers are running ($COMPOSE_CMD ps)"
    echo ""
    echo "3. If performance is poor:"
    echo "   - Monitor resource usage (docker stats)"
    echo "   - Check system load (top, htop)"
    echo "   - Review disk I/O (iotop if available)"
    echo ""
    echo "4. For SSL/HTTPS issues:"
    echo "   - Regenerate certificates if expired"
    echo "   - Check certificate permissions"
    echo "   - Verify certificate paths in configuration"
    echo ""

    print_header "END OF DIAGNOSTIC REPORT"
    echo "Report saved to: $REPORT_FILE"

} | tee "$REPORT_FILE"

echo ""
echo -e "${GREEN}Diagnostic report generated successfully!${NC}"
echo -e "${BLUE}Report file: $REPORT_FILE${NC}"
echo ""
echo "You can share this report with support teams for troubleshooting."
echo "Note: Sensitive information has been masked in the report."
