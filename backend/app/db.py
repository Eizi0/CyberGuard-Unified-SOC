from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings

_client = None

async def init_db():
    global _client
    _client = AsyncIOMotorClient(settings.MONGODB_URI)
    
async def get_database():
    if not _client:
        await init_db()
    return _client[settings.DATABASE_NAME]

async def close_db():
    if _client:
        _client.close()
