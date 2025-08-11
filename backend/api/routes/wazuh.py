from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Optional
from integrations.wazuh.client import WazuhClient
from core.exceptions import IntegrationError

router = APIRouter()
client = WazuhClient()

@router.get("/agents")
async def get_agents(status: Optional[str] = None) -> List[Dict]:
    """Get list of Wazuh agents"""
    try:
        return await client.get_agents(status)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/agents/{agent_id}")
async def get_agent(agent_id: str) -> Dict:
    """Get specific agent details"""
    try:
        return await client.get_agent_status(agent_id)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/alerts")
async def get_alerts(limit: int = 100, offset: int = 0) -> List[Dict]:
    """Get Wazuh alerts"""
    try:
        return await client.get_alerts(limit, offset)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/rules")
async def get_rules(limit: int = 100, offset: int = 0) -> List[Dict]:
    """Get Wazuh detection rules"""
    try:
        return await client.get_rules(limit, offset)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.put("/agents/{agent_id}/restart")
async def restart_agent(agent_id: str) -> Dict:
    """Restart a specific agent"""
    try:
        return await client.restart_agent(agent_id)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/agents/{agent_id}/config/{component}")
async def get_agent_config(agent_id: str, component: str) -> Dict:
    """Get agent configuration"""
    try:
        return await client.get_agent_config(agent_id, component)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))
