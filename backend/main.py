from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings

app = FastAPI(
    title="CyberGuard Unified SOC API",
    description="API Backend for CyberGuard Unified SOC",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://frontend:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import and include routers
from app.routers import auth, graylog, misp, opencti, shuffle, thehive, velociraptor, wazuh

app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(wazuh.router, prefix="/api/wazuh", tags=["Wazuh"])
app.include_router(graylog.router, prefix="/api/graylog", tags=["Graylog"])
app.include_router(thehive.router, prefix="/api/thehive", tags=["TheHive"])
app.include_router(misp.router, prefix="/api/misp", tags=["MISP"])
app.include_router(opencti.router, prefix="/api/opencti", tags=["OpenCTI"])
app.include_router(velociraptor.router, prefix="/api/velociraptor", tags=["Velociraptor"])
app.include_router(shuffle.router, prefix="/api/shuffle", tags=["Shuffle"])

@app.get("/")
async def root():
    return {
        "name": "CyberGuard Unified SOC API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "cyberguard-backend",
        "timestamp": "2025-08-13T00:00:00Z"
    }
