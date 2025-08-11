from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings
from app.routers import wazuh, graylog, thehive, misp, opencti, velociraptor, shuffle
from app.db import init_db

app = FastAPI(
    title="CyberGuard Unified SOC API",
    description="API for integrating various security tools in a unified SOC platform",
    version="1.0.0"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Event handlers
@app.on_event("startup")
async def startup_event():
    await init_db()

# Include routers
app.include_router(wazuh.router, prefix="/api/wazuh", tags=["Wazuh"])
app.include_router(graylog.router, prefix="/api/graylog", tags=["Graylog"])
app.include_router(thehive.router, prefix="/api/thehive", tags=["TheHive"])
app.include_router(misp.router, prefix="/api/misp", tags=["MISP"])
app.include_router(opencti.router, prefix="/api/opencti", tags=["OpenCTI"])
app.include_router(velociraptor.router, prefix="/api/velociraptor", tags=["Velociraptor"])
app.include_router(shuffle.router, prefix="/api/shuffle", tags=["Shuffle"])

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy"}
