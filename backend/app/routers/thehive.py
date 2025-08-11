from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_thehive_client():
    base_url = settings.THEHIVE_URL
    headers = {"Authorization": f"Bearer {settings.THEHIVE_API_KEY}"}
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/cases")
async def list_cases(client: httpx.AsyncClient = Depends(get_thehive_client)):
    """List all cases"""
    try:
        response = await client.get("/api/case")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/cases")
async def create_case(case: Dict[str, Any], client: httpx.AsyncClient = Depends(get_thehive_client)):
    """Create a new case"""
    try:
        response = await client.post("/api/case", json=case)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/cases/{case_id}")
async def get_case(case_id: str, client: httpx.AsyncClient = Depends(get_thehive_client)):
    """Get a specific case"""
    try:
        response = await client.get(f"/api/case/{case_id}")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/cases/{case_id}/tasks")
async def create_task(
    case_id: str,
    task: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_thehive_client)
):
    """Create a new task in a case"""
    try:
        response = await client.post(f"/api/case/{case_id}/task", json=task)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/cases/{case_id}/tasks")
async def list_tasks(case_id: str, client: httpx.AsyncClient = Depends(get_thehive_client)):
    """List all tasks in a case"""
    try:
        response = await client.get(f"/api/case/{case_id}/task")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/cases/{case_id}/observables")
async def create_observable(
    case_id: str,
    observable: Dict[str, Any],
    client: httpx.AsyncClient = Depends(get_thehive_client)
):
    """Create a new observable in a case"""
    try:
        response = await client.post(f"/api/case/{case_id}/observable", json=observable)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/alerts")
async def list_alerts(client: httpx.AsyncClient = Depends(get_thehive_client)):
    """List all alerts"""
    try:
        response = await client.get("/api/alert")
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/alerts")
async def create_alert(alert: Dict[str, Any], client: httpx.AsyncClient = Depends(get_thehive_client)):
    """Create a new alert"""
    try:
        response = await client.post("/api/alert", json=alert)
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
