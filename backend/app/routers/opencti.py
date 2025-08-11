from fastapi import APIRouter, HTTPException, Depends
from typing import List, Dict, Any
import httpx
from app.config import settings

router = APIRouter()

async def get_opencti_client():
    base_url = settings.OPENCTI_URL
    headers = {
        "Authorization": f"Bearer {settings.OPENCTI_API_KEY}",
        "Content-Type": "application/json"
    }
    async with httpx.AsyncClient(base_url=base_url, headers=headers) as client:
        yield client

@router.get("/threats")
async def list_threats(client: httpx.AsyncClient = Depends(get_opencti_client)):
    """List all threat actors"""
    try:
        query = """
        query {
            threatActors {
                edges {
                    node {
                        id
                        name
                        description
                        created
                    }
                }
            }
        }
        """
        response = await client.post("/graphql", json={"query": query})
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/indicators")
async def list_indicators(client: httpx.AsyncClient = Depends(get_opencti_client)):
    """List all indicators"""
    try:
        query = """
        query {
            indicators {
                edges {
                    node {
                        id
                        name
                        pattern
                        valid_from
                        valid_until
                    }
                }
            }
        }
        """
        response = await client.post("/graphql", json={"query": query})
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/indicators")
async def create_indicator(indicator: Dict[str, Any], client: httpx.AsyncClient = Depends(get_opencti_client)):
    """Create a new indicator"""
    try:
        mutation = """
        mutation CreateIndicator($input: IndicatorAddInput!) {
            indicatorAdd(input: $input) {
                id
                name
                pattern
            }
        }
        """
        response = await client.post("/graphql", json={
            "query": mutation,
            "variables": {"input": indicator}
        })
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/reports")
async def list_reports(client: httpx.AsyncClient = Depends(get_opencti_client)):
    """List all reports"""
    try:
        query = """
        query {
            reports {
                edges {
                    node {
                        id
                        name
                        description
                        published
                    }
                }
            }
        }
        """
        response = await client.post("/graphql", json={"query": query})
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/reports")
async def create_report(report: Dict[str, Any], client: httpx.AsyncClient = Depends(get_opencti_client)):
    """Create a new report"""
    try:
        mutation = """
        mutation CreateReport($input: ReportAddInput!) {
            reportAdd(input: $input) {
                id
                name
                description
            }
        }
        """
        response = await client.post("/graphql", json={
            "query": mutation,
            "variables": {"input": report}
        })
        return response.json()
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=str(e))
