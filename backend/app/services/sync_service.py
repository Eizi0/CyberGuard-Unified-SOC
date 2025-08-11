import asyncio
from datetime import datetime
from typing import Dict, Any, List
from app.config import settings
from app.db import get_database
from app.routers import wazuh, graylog, thehive, misp, opencti, velociraptor, shuffle

class SyncService:
    def __init__(self):
        self.db = None
        
    async def init_db(self):
        self.db = await get_database()

    async def sync_alerts(self):
        """Synchronize alerts from all sources"""
        alerts = []
        
        # Get Wazuh alerts
        try:
            wazuh_alerts = await wazuh.get_alerts()
            for alert in wazuh_alerts:
                alerts.append({
                    "source": "wazuh",
                    "timestamp": datetime.utcnow(),
                    "data": alert
                })
        except Exception as e:
            print(f"Error fetching Wazuh alerts: {e}")

        # Get Graylog alerts
        try:
            graylog_alerts = await graylog.get_alerts()
            for alert in graylog_alerts:
                alerts.append({
                    "source": "graylog",
                    "timestamp": datetime.utcnow(),
                    "data": alert
                })
        except Exception as e:
            print(f"Error fetching Graylog alerts: {e}")

        # Store synchronized alerts
        if alerts:
            await self.db.synchronized_alerts.insert_many(alerts)

    async def sync_iocs(self):
        """Synchronize IoCs between MISP and OpenCTI"""
        # Get MISP attributes (IoCs)
        try:
            misp_iocs = await misp.list_attributes()
            
            # Convert MISP IoCs to OpenCTI format
            for ioc in misp_iocs:
                opencti_indicator = self._convert_misp_to_opencti(ioc)
                await opencti.create_indicator(opencti_indicator)
        except Exception as e:
            print(f"Error synchronizing IoCs: {e}")

    async def sync_cases(self):
        """Synchronize cases between TheHive and other platforms"""
        try:
            # Get TheHive cases
            thehive_cases = await thehive.list_cases()
            
            # Create corresponding tasks in Shuffle for automation
            for case in thehive_cases:
                workflow_data = self._create_workflow_from_case(case)
                await shuffle.create_workflow(workflow_data)
        except Exception as e:
            print(f"Error synchronizing cases: {e}")

    def _convert_misp_to_opencti(self, misp_ioc: Dict[str, Any]) -> Dict[str, Any]:
        """Convert MISP IoC to OpenCTI format"""
        return {
            "name": misp_ioc.get("value", "Unknown IoC"),
            "description": misp_ioc.get("comment", ""),
            "pattern": misp_ioc.get("value", ""),
            "pattern_type": misp_ioc.get("type", "stix"),
            "valid_from": misp_ioc.get("timestamp", datetime.utcnow().isoformat()),
            "markings": ["TLP:WHITE"]
        }

    def _create_workflow_from_case(self, case: Dict[str, Any]) -> Dict[str, Any]:
        """Create Shuffle workflow from TheHive case"""
        return {
            "name": f"Case Automation - {case.get('title', 'Unknown')}",
            "description": case.get("description", ""),
            "triggers": [{
                "type": "webhook",
                "name": "Case Update Trigger"
            }],
            "actions": [
                {
                    "type": "thehive",
                    "name": "Update Case Status"
                },
                {
                    "type": "email",
                    "name": "Send Notification"
                }
            ]
        }

    async def start_sync_loop(self):
        """Start continuous synchronization loop"""
        await self.init_db()
        while True:
            try:
                await self.sync_alerts()
                await self.sync_iocs()
                await self.sync_cases()
            except Exception as e:
                print(f"Error in sync loop: {e}")
            
            # Wait for 5 minutes before next sync
            await asyncio.sleep(300)
