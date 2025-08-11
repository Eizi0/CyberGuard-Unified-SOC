from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_misp_client():
    base_url = settings.MISP_URL
    headers = {
        "Authorization": settings.MISP_API_KEY,
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/events")
async def list_events(client: httpx.AsyncClient = Depends(get_misp_client)):
    """List all MISP events"""
    try:
        response = await client.get("/events")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/events")
async def create_event(event: Dict[str, Any], client: httpx.AsyncClient = Depends(get_misp_client)):
    """Create a new MISP event"""
    try:
        response = await client.post("/events", json=event)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/attributes")
async def list_attributes(client: httpx.AsyncClient = Depends(get_misp_client)):
    """List all attributes"""
    try:
        response = await client.get("/attributes")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/attributes")
async def create_attribute(
    attribute: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_misp_client)
):
    """Create a new attribute"""
    try:
        response = await client.post("/attributes", json=attribute)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/tags")
async def list_tags(client: httpx.AsyncClient = Depends(get_misp_client)):
    """List all tags"""
    try:
        response = await client.get("/tags")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/tags")
async def create_tag(tag: Dict[str, Any], client: httpx.AsyncClient = Depends(get_misp_client)):
    """Create a new tag"""
    try:
        response = await client.post("/tags", json=tag)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
