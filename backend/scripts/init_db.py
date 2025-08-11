import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings

async def init_test_data():
    # Connect to MongoDB
    client = AsyncIOMotorClient(settings.MONGODB_URI)
    db = client[settings.DATABASE_NAME]
    
    # Create collections if they don't exist
    await db.create_collection("users")
    await db.create_collection("alerts")
    await db.create_collection("cases")
    await db.create_collection("integrations")
    
    # Add test user
    test_user = {
        "username": "admin",
        "email": "admin@cyberguard.com",
        "role": "admin"
    }
    await db.users.insert_one(test_user)
    
    # Add test integration settings
    test_integrations = [
        {
            "name": "wazuh",
            "enabled": True,
            "config": {
                "host": settings.WAZUH_HOST,
                "port": settings.WAZUH_PORT
            }
        },
        {
            "name": "graylog",
            "enabled": True,
            "config": {
                "host": settings.GRAYLOG_HOST,
                "port": settings.GRAYLOG_PORT
            }
        },
        {
            "name": "thehive",
            "enabled": True,
            "config": {
                "url": settings.THEHIVE_URL
            }
        }
    ]
    await db.integrations.insert_many(test_integrations)
    
    # Add test alerts
    test_alerts = [
        {
            "title": "Suspicious Activity Detected",
            "source": "wazuh",
            "severity": "high",
            "status": "new",
            "description": "Multiple failed login attempts detected"
        },
        {
            "title": "Malware Detection",
            "source": "thehive",
            "severity": "critical",
            "status": "in_progress",
            "description": "Potential malware detected in system files"
        }
    ]
    await db.alerts.insert_many(test_alerts)
    
    print("Test data initialized successfully!")

if __name__ == "__main__":
    asyncio.run(init_test_data())
