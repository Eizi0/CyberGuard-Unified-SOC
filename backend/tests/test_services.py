import pytest
from datetime import datetime, timedelta
from app.services.correlation_service import CorrelationService
from app.services.sync_service import SyncService

@pytest.fixture
async def correlation_service():
    service = CorrelationService()
    await service.init_db()
    return service

@pytest.fixture
async def sync_service():
    service = SyncService()
    await service.init_db()
    return service

@pytest.mark.asyncio
async def test_correlate_alerts(correlation_service, test_db):
    # Create test alerts
    test_alerts = [
        {
            "source": "wazuh",
            "timestamp": datetime.utcnow(),
            "source_ip": "192.168.1.100",
            "type": "authentication_failure"
        },
        {
            "source": "wazuh",
            "timestamp": datetime.utcnow(),
            "source_ip": "192.168.1.100",
            "type": "authentication_failure"
        },
        {
            "source": "graylog",
            "timestamp": datetime.utcnow(),
            "source_ip": "192.168.1.101",
            "type": "malware_detected"
        }
    ]
    
    await test_db.alerts.insert_many(test_alerts)
    
    # Test correlation
    correlation = await correlation_service.correlate_alerts()
    assert correlation is not None
    assert "brute_force_attempts" in correlation
    assert correlation["brute_force_attempts"]["detected"]
    assert "192.168.1.100" in correlation["brute_force_attempts"]["attempts"]

@pytest.mark.asyncio
async def test_sync_alerts(sync_service, test_db):
    # Test alert synchronization
    num_alerts = await sync_service.sync_alerts()
    assert isinstance(num_alerts, int)
    
    # Verify alerts were stored
    alerts = await test_db.synchronized_alerts.find({}).to_list(None)
    assert len(alerts) > 0

@pytest.mark.asyncio
async def test_sync_iocs(sync_service, test_db):
    # Test IOC synchronization
    num_iocs = await sync_service.sync_iocs()
    assert isinstance(num_iocs, int)
    
    # Verify IOCs were stored
    iocs = await test_db.synchronized_iocs.find({}).to_list(None)
    assert len(iocs) > 0

@pytest.mark.asyncio
async def test_sync_cases(sync_service, test_db):
    # Test case synchronization
    num_cases = await sync_service.sync_cases()
    assert isinstance(num_cases, int)
    
    # Verify cases were stored
    cases = await test_db.synchronized_cases.find({}).to_list(None)
    assert len(cases) > 0
