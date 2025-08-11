from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_velociraptor_client():
    base_url = settings.VELOCIRAPTOR_URL
    headers = {
        "Authorization": f"Bearer {settings.VELOCIRAPTOR_API_KEY}",
        "Content-Type": "application/json"
    }
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/clients")
async def list_clients(client: httpx.AsyncClient = Depends(get_velociraptor_client)):
    """List all Velociraptor clients"""
    try:
        response = await client.get("/api/v1/clients")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/clients/{client_id}")
async def get_client(
    client_id: str,
    client: httpx.AsyncClient = Depends(get_velociraptor_client)
):
    """Get specific client details"""
    try:
        response = await client.get(f"/api/v1/clients/{client_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/collections")
async def create_collection(
    collection: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_velociraptor_client)
):
    """Create a new collection"""
    try:
        response = await client.post("/api/v1/collections", json=collection)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/collections/{collection_id}")
async def get_collection(
    collection_id: str,
    client: httpx.AsyncClient = Depends(get_velociraptor_client)
):
    """Get collection results"""
    try:
        response = await client.get(f"/api/v1/collections/{collection_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/hunts")
async def create_hunt(
    hunt: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_velociraptor_client)
):
    """Create a new hunt"""
    try:
        response = await client.post("/api/v1/hunts", json=hunt)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/hunts")
async def list_hunts(client: httpx.AsyncClient = Depends(get_velociraptor_client)):
    """List all hunts"""
    try:
        response = await client.get("/api/v1/hunts")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
