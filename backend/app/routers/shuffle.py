from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_shuffle_client():
    base_url = settings.SHUFFLE_URL
    headers = {
        "Authorization": f"Bearer {settings.SHUFFLE_API_KEY}",
        "Content-Type": "application/json"
    }
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/workflows")
async def list_workflows(client: httpx.AsyncClient = Depends(get_shuffle_client)):
    """List all workflows"""
    try:
        response = await client.get("/api/v1/workflows")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/workflows")
async def create_workflow(
    workflow: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_shuffle_client)
):
    """Create a new workflow"""
    try:
        response = await client.post("/api/v1/workflows", json=workflow)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/workflows/{workflow_id}")
async def get_workflow(
    workflow_id: str,
    client: httpx.AsyncClient = Depends(get_shuffle_client)
):
    """Get specific workflow"""
    try:
        response = await client.get(f"/api/v1/workflows/{workflow_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/workflows/{workflow_id}/execute")
async def execute_workflow(
    workflow_id: str,
    input_data: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_shuffle_client)
):
    """Execute a workflow"""
    try:
        response = await client.post(
            f"/api/v1/workflows/{workflow_id}/execute",
            json=input_data
        )
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/apps")
async def list_apps(client: httpx.AsyncClient = Depends(get_shuffle_client)):
    """List all available apps"""
    try:
        response = await client.get("/api/v1/apps")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/workflows/{workflow_id}/save")
async def save_workflow(
    workflow_id: str,
    workflow_data: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_shuffle_client)
):
    """Save workflow changes"""
    try:
        response = await client.put(
            f"/api/v1/workflows/{workflow_id}",
            json=workflow_data
        )
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
