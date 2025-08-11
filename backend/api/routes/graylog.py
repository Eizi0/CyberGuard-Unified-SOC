from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Optional
from integrations.graylog.client import GraylogClient
from core.exceptions import IntegrationError

router = APIRouter()
client = GraylogClient()

@router.get("/streams")
async def get_streams() -> List[Dict]:
    """Get all Graylog streams"""
    try:
        return await client.get_streams()
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/dashboards")
async def get_dashboards() -> List[Dict]:
    """Get all Graylog dashboards"""
    try:
        return await client.get_dashboards()
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/search")
async def search_messages(
    query: str,
    timerange: Optional[Dict] = None,
    limit: int = 100
) -> List[Dict]:
    """Search Graylog messages"""
    try:
        return await client.search_messages(query, timerange, limit)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/stats")
async def get_system_stats() -> Dict:
    """Get Graylog system statistics"""
    try:
        return await client.get_system_stats()
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/inputs")
async def get_inputs() -> List[Dict]:
    """Get all Graylog inputs"""
    try:
        return await client.get_inputs()
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/inputs")
async def create_input(input_data: Dict) -> Dict:
    """Create a new Graylog input"""
    try:
        return await client.create_input(input_data)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.delete("/inputs/{input_id}")
async def delete_input(input_id: str) -> None:
    """Delete a Graylog input"""
    try:
        await client.delete_input(input_id)
        return {"message": "Input deleted successfully"}
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/alerts")
async def get_alerts(limit: int = 100) -> List[Dict]:
    """Get recent Graylog alerts"""
    try:
        return await client.get_alerts(limit)
    except IntegrationError as e:
        raise HTTPException(status_code=500, detail=str(e))
