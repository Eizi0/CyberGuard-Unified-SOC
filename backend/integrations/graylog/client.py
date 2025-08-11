from typing import Dict, List, Optional
import aiohttp
from core.config import settings
from core.exceptions import IntegrationError

class GraylogClient:
    def __init__(self):
        self.base_url = settings.GRAYLOG_HOST
        self.username = settings.GRAYLOG_USERNAME
        self.password = settings.GRAYLOG_PASSWORD

    async def _request(self, method: str, endpoint: str, **kwargs) -> Dict:
        """Make authenticated request to Graylog API"""
        auth = aiohttp.BasicAuth(self.username, self.password)
        
        async with aiohttp.ClientSession(auth=auth) as session:
            try:
                url = f"{self.base_url}/api/{endpoint}"
                async with getattr(session, method)(url, **kwargs) as response:
                    if response.status == 401:
                        raise IntegrationError("Authentication failed")
                    return await response.json()
            except Exception as e:
                raise IntegrationError(f"Graylog API request failed: {str(e)}")

    async def get_streams(self) -> List[Dict]:
        """Get all streams"""
        response = await self._request("get", "streams")
        return response.get("streams", [])

    async def get_dashboards(self) -> List[Dict]:
        """Get all dashboards"""
        response = await self._request("get", "dashboards")
        return response.get("dashboards", [])

    async def search_messages(
        self, 
        query: str, 
        timerange: Dict = None, 
        limit: int = 100
    ) -> List[Dict]:
        """Search messages"""
        params = {
            "query": query,
            "limit": limit,
            **(timerange or {"range": 300})  # Default to last 5 minutes
        }
        response = await self._request("get", "search/universal/relative", params=params)
        return response.get("messages", [])

    async def get_system_stats(self) -> Dict:
        """Get system statistics"""
        response = await self._request("get", "system/stats")
        return response

    async def get_inputs(self) -> List[Dict]:
        """Get all inputs"""
        response = await self._request("get", "system/inputs")
        return response.get("inputs", [])

    async def create_input(self, input_data: Dict) -> Dict:
        """Create a new input"""
        response = await self._request("post", "system/inputs", json=input_data)
        return response

    async def delete_input(self, input_id: str) -> None:
        """Delete an input"""
        await self._request("delete", f"system/inputs/{input_id}")

    async def get_alerts(self, limit: int = 100) -> List[Dict]:
        """Get recent alerts"""
        response = await self._request(
            "get", 
            "streams/alerts", 
            params={"limit": limit}
        )
        return response.get("alerts", [])
