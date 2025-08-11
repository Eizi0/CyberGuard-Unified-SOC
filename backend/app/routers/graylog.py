from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_graylog_client():
    base_url = f"http://{settings.GRAYLOG_HOST}:{settings.GRAYLOG_PORT}/api"
    headers = {"Authorization": f"Bearer {settings.GRAYLOG_API_TOKEN}"}
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/system/overview")
async def get_system_overview(client: httpx.AsyncClient = Depends(get_graylog_client)):
    """Get Graylog system overview"""
    try:
        response = await client.get("/system/overview")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/streams")
async def list_streams(client: httpx.AsyncClient = Depends(get_graylog_client)):
    """List all streams"""
    try:
        response = await client.get("/streams")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/streams")
async def create_stream(stream: Dict[str, Any], client: httpx.AsyncClient = Depends(get_graylog_client)):
    """Create a new stream"""
    try:
        response = await client.post("/streams", json=stream)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/inputs")
async def list_inputs(client: httpx.AsyncClient = Depends(get_graylog_client)):
    """List all inputs"""
    try:
        response = await client.get("/system/inputs")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/inputs")
async def create_input(input_config: Dict[str, Any], client: httpx.AsyncClient = Depends(get_graylog_client)):
    """Create a new input"""
    try:
        response = await client.post("/system/inputs", json=input_config)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/dashboards")
async def list_dashboards(client: httpx.AsyncClient = Depends(get_graylog_client)):
    """List all dashboards"""
    try:
        response = await client.get("/dashboards")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/search/absolute")
async def search_absolute(
    query: str,
    from_time: str,
    to_time: str,
    client: httpx.AsyncClient = Depends(get_graylog_client)
):
    """Search messages in an absolute timerange"""
    try:
        params = {
            "query": query,
            "from": from_time,
            "to": to_time
        }
        response = await client.get("/search/absolute", params=params)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/system/notifications")
async def get_notifications(client: httpx.AsyncClient = Depends(get_graylog_client)):
    """Get system notifications"""
    try:
        response = await client.get("/system/notifications")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
