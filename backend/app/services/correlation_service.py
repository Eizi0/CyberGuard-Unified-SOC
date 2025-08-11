from datetime import datetime, timedelta
from typing import Dict, Any, List
from app.db import get_database

class CorrelationService:
    def __init__(self):
        self.db = None
        
    async def init_db(self):
        self.db = await get_database()

    async def correlate_alerts(self):
        """Correlate alerts from different sources based on various factors"""
        now = datetime.utcnow()
        time_window = now - timedelta(hours=1)
        
        # Get recent alerts from all sources
        alerts = await self.db.synchronized_alerts.find({
            "timestamp": {"$gte": time_window}
        }).to_list(length=None)

        # Group alerts by IP addresses
        ip_correlations = self._group_by_ip(alerts)
        
        # Group alerts by hostname
        host_correlations = self._group_by_hostname(alerts)
        
        # Analyze attack patterns
        attack_patterns = self._analyze_attack_patterns(alerts)
        
        # Store correlation results
        await self.store_correlations(ip_correlations, host_correlations, attack_patterns)

    def _group_by_ip(self, alerts: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
        """Group alerts by source/destination IP addresses"""
        ip_groups = {}
        
        for alert in alerts:
            # Extract IPs from alert data
            source_ip = self._extract_ip(alert, "source")
            dest_ip = self._extract_ip(alert, "destination")
            
            if source_ip:
                if source_ip not in ip_groups:
                    ip_groups[source_ip] = []
                ip_groups[source_ip].append(alert)
                
            if dest_ip:
                if dest_ip not in ip_groups:
                    ip_groups[dest_ip] = []
                ip_groups[dest_ip].append(alert)
        
        return ip_groups

    def _group_by_hostname(self, alerts: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
        """Group alerts by hostname"""
        host_groups = {}
        
        for alert in alerts:
            hostname = self._extract_hostname(alert)
            if hostname:
                if hostname not in host_groups:
                    host_groups[hostname] = []
                host_groups[hostname].append(alert)
        
        return host_groups

    def _analyze_attack_patterns(self, alerts: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Analyze alerts for common attack patterns"""
        patterns = []
        
        # Look for brute force attempts
        brute_force = self._detect_brute_force(alerts)
        if brute_force:
            patterns.append(brute_force)
        
        # Look for port scanning
        port_scan = self._detect_port_scan(alerts)
        if port_scan:
            patterns.append(port_scan)
        
        # Look for malware indicators
        malware = self._detect_malware(alerts)
        if malware:
            patterns.append(malware)
        
        return patterns

    def _detect_brute_force(self, alerts: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Detect potential brute force attacks"""
        auth_failures = {}
        
        for alert in alerts:
            if self._is_auth_failure(alert):
                source_ip = self._extract_ip(alert, "source")
                if source_ip:
                    auth_failures[source_ip] = auth_failures.get(source_ip, 0) + 1
        
        # Identify IPs with high number of auth failures
        suspicious_ips = {
            ip: count for ip, count in auth_failures.items() 
            if count >= 10  # Threshold for brute force detection
        }
        
        if suspicious_ips:
            return {
                "type": "brute_force",
                "description": "Potential brute force attack detected",
                "suspicious_ips": suspicious_ips
            }
        return None

    def _detect_port_scan(self, alerts: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Detect potential port scanning activity"""
        port_access = {}
        
        for alert in alerts:
            source_ip = self._extract_ip(alert, "source")
            dest_port = self._extract_port(alert)
            
            if source_ip and dest_port:
                if source_ip not in port_access:
                    port_access[source_ip] = set()
                port_access[source_ip].add(dest_port)
        
        # Identify IPs accessing many different ports
        suspicious_ips = {
            ip: len(ports) for ip, ports in port_access.items() 
            if len(ports) >= 10  # Threshold for port scan detection
        }
        
        if suspicious_ips:
            return {
                "type": "port_scan",
                "description": "Potential port scanning activity detected",
                "suspicious_ips": suspicious_ips
            }
        return None

    def _detect_malware(self, alerts: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Detect potential malware activity"""
        malware_indicators = {}
        
        for alert in alerts:
            if self._has_malware_indicators(alert):
                source_ip = self._extract_ip(alert, "source")
                if source_ip:
                    if source_ip not in malware_indicators:
                        malware_indicators[source_ip] = []
                    malware_indicators[source_ip].append(alert)
        
        if malware_indicators:
            return {
                "type": "malware",
                "description": "Potential malware activity detected",
                "affected_hosts": malware_indicators
            }
        return None

    async def store_correlations(self, ip_correlations, host_correlations, attack_patterns):
        """Store correlation results in the database"""
        correlation_data = {
            "timestamp": datetime.utcnow(),
            "ip_correlations": ip_correlations,
            "host_correlations": host_correlations,
            "attack_patterns": attack_patterns
        }
        
        await self.db.correlations.insert_one(correlation_data)

    # Helper methods
    def _extract_ip(self, alert: Dict[str, Any], direction: str) -> str:
        """Extract IP address from alert based on direction"""
        data = alert.get("data", {})
        
        # Check different possible field names based on alert source
        if direction == "source":
            return (
                data.get("srcip") or
                data.get("source_ip") or
                data.get("src") or
                None
            )
        else:
            return (
                data.get("dstip") or
                data.get("destination_ip") or
                data.get("dst") or
                None
            )

    def _extract_hostname(self, alert: Dict[str, Any]) -> str:
        """Extract hostname from alert"""
        data = alert.get("data", {})
        return (
            data.get("hostname") or
            data.get("host") or
            data.get("system_name") or
            None
        )

    def _extract_port(self, alert: Dict[str, Any]) -> int:
        """Extract port number from alert"""
        data = alert.get("data", {})
        return (
            data.get("dstport") or
            data.get("destination_port") or
            data.get("port") or
            None
        )

    def _is_auth_failure(self, alert: Dict[str, Any]) -> bool:
        """Check if alert indicates authentication failure"""
        data = alert.get("data", {})
        
        # Common authentication failure indicators
        indicators = [
            "authentication failure",
            "login failed",
            "invalid password",
            "access denied"
        ]
        
        message = str(data.get("message", "")).lower()
        return any(indicator in message for indicator in indicators)

    def _has_malware_indicators(self, alert: Dict[str, Any]) -> bool:
        """Check if alert has malware indicators"""
        data = alert.get("data", {})
        
        # Common malware indicators
        indicators = [
            "malware",
            "virus",
            "trojan",
            "backdoor",
            "ransomware",
            "suspicious binary"
        ]
        
        message = str(data.get("message", "")).lower()
        return any(indicator in message for indicator in indicators)
