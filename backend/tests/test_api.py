import pytest
from httpx import AsyncClient
from app.main import app
from app.db import get_database

@pytest.fixture
async def test_client():
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client

@pytest.fixture
async def test_db():
    db = await get_database()
    yield db
    # Cleanup after tests
    await db.drop_collection("users")
    await db.drop_collection("alerts")
    await db.drop_collection("cases")

@pytest.mark.asyncio
async def test_wazuh_agents_list(test_client):
    response = await test_client.get("/api/wazuh/agents")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_graylog_streams_list(test_client):
    response = await test_client.get("/api/graylog/streams")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_thehive_cases_list(test_client):
    response = await test_client.get("/api/thehive/cases")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_misp_events_list(test_client):
    response = await test_client.get("/api/misp/events")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_opencti_threats_list(test_client):
    response = await test_client.get("/api/opencti/threats")
    assert response.status_code == 200
    data = response.json()
    assert "data" in data
    assert "threatActors" in data["data"]

@pytest.mark.asyncio
async def test_velociraptor_clients_list(test_client):
    response = await test_client.get("/api/velociraptor/clients")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_shuffle_workflows_list(test_client):
    response = await test_client.get("/api/shuffle/workflows")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

@pytest.mark.asyncio
async def test_auth_login(test_client, test_db):
    # Create test user
    test_user = {
        "username": "testuser",
        "password": "testpass123",
        "email": "test@example.com"
    }
    await test_client.post("/api/auth/users/", json=test_user)
    
    # Try to login
    response = await test_client.post("/api/auth/token", data={
        "username": test_user["username"],
        "password": test_user["password"]
    })
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "token_type" in data
    assert data["token_type"] == "bearer"
