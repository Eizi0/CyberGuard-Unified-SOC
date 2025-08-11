from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_wazuh_client():
    base_url = f"https://{settings.WAZUH_HOST}:{settings.WAZUH_PORT}"
    auth = httpx.BasicAuth(settings.WAZUH_USER, settings.WAZUH_PASSWORD)
    async with httpx.AsyncClient(base_url=base_url, auth=auth, verify=False) as client:
        yield client

@router.get("/agents")
async def list_agents(client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """List all Wazuh agents"""
    try:
        response = await client.get("/agents")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/agents/{agent_id}")
async def get_agent(agent_id: str, client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """Get specific agent details"""
    try:
        response = await client.get(f"/agents/{agent_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/alerts")
async def get_alerts(limit: int = 100, client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """Get recent alerts"""
    try:
        response = await client.get("/alerts", params={"limit": limit})
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/groups")
async def list_groups(client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """List all agent groups"""
    try:
        response = await client.get("/groups")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/agents/{agent_id}/group/{group_id}")
async def add_agent_to_group(
    agent_id: str, 
    group_id: str, 
    client: httpx.AsyncClient = Depends(get_wazuh_client)
):
    """Add an agent to a group"""
    try:
        response = await client.put(f"/agents/{agent_id}/group/{group_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/rules")
async def list_rules(client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """List all rules"""
    try:
        response = await client.get("/rules")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/decoders")
async def list_decoders(client: httpx.AsyncClient = Depends(get_wazuh_client)):
    """List all decoders"""
    try:
        response = await client.get("/decoders")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
