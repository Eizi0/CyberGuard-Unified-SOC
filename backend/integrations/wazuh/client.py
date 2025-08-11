from typing import Dict, List, Optional
import aiohttp
from core.config import settings
from core.exceptions import IntegrationError

class WazuhClient:
    def __init__(self):
        self.base_url = settings.WAZUH_HOST
        self.username = settings.WAZUH_USERNAME
        self.password = settings.WAZUH_PASSWORD
        self.token = None

    async def _get_token(self) -> str:
        """Get authentication token from Wazuh API"""
        async with aiohttp.ClientSession() as session:
            try:
                auth_url = f"{self.base_url}/security/user/authenticate"
                async with session.post(
                    auth_url,
                    auth=aiohttp.BasicAuth(self.username, self.password)
                ) as response:
                    if response.status == 200:
                        data = await response.json()
                        return data["token"]
                    raise IntegrationError(f"Authentication failed: {response.status}")
            except Exception as e:
                raise IntegrationError(f"Connection to Wazuh failed: {str(e)}")

    async def _request(self, method: str, endpoint: str, **kwargs) -> Dict:
        """Make authenticated request to Wazuh API"""
        if not self.token:
            self.token = await self._get_token()

        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }

        async with aiohttp.ClientSession(headers=headers) as session:
            try:
                url = f"{self.base_url}/{endpoint}"
                async with getattr(session, method)(url, **kwargs) as response:
                    if response.status == 401:
                        # Token expired, get new token and retry
                        self.token = await self._get_token()
                        headers["Authorization"] = f"Bearer {self.token}"
                        async with getattr(session, method)(url, **kwargs) as retry_response:
                            return await retry_response.json()
                    return await response.json()
            except Exception as e:
                raise IntegrationError(f"Wazuh API request failed: {str(e)}")

    async def get_agents(self, status: Optional[str] = None) -> List[Dict]:
        """Get list of all agents"""
        params = {"status": status} if status else None
        response = await self._request("get", "agents", params=params)
        return response.get("data", {}).get("affected_items", [])

    async def get_alerts(self, limit: int = 100, offset: int = 0) -> List[Dict]:
        """Get recent alerts"""
        params = {"limit": limit, "offset": offset}
        response = await self._request("get", "alerts", params=params)
        return response.get("data", {}).get("affected_items", [])

    async def get_rules(self, limit: int = 100, offset: int = 0) -> List[Dict]:
        """Get detection rules"""
        params = {"limit": limit, "offset": offset}
        response = await self._request("get", "rules", params=params)
        return response.get("data", {}).get("affected_items", [])

    async def get_agent_status(self, agent_id: str) -> Dict:
        """Get specific agent status"""
        response = await self._request("get", f"agents/{agent_id}")
        return response.get("data", {}).get("affected_items", [{}])[0]

    async def restart_agent(self, agent_id: str) -> Dict:
        """Restart a specific agent"""
        response = await self._request("put", f"agents/{agent_id}/restart")
        return response

    async def get_agent_config(self, agent_id: str, component: str) -> Dict:
        """Get agent configuration"""
        response = await self._request("get", f"agents/{agent_id}/config/{component}")
        return response.get("data", {})
