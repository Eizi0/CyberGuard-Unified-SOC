from pydantic import BaseSettings
from typing import Optional, List

class Settings(BaseSettings):
    # CORS settings
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://frontend:3000",
        "http://127.0.0.1:3000"
    ]
    
    # MongoDB settings
    MONGODB_URI: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "cyberguard"

    # Wazuh settings
    WAZUH_HOST: str = "localhost"
    WAZUH_PORT: int = 55000
    WAZUH_USER: str = "wazuh"
    WAZUH_PASSWORD: str = "wazuh"

    # Graylog settings
    GRAYLOG_HOST: str = "localhost"
    GRAYLOG_PORT: int = 9000
    GRAYLOG_API_TOKEN: Optional[str] = None

    # TheHive settings
    THEHIVE_URL: str = "http://localhost:9000"
    THEHIVE_API_KEY: Optional[str] = None

    # MISP settings
    MISP_URL: str = "http://localhost"
    MISP_API_KEY: Optional[str] = None

    # OpenCTI settings
    OPENCTI_URL: str = "http://localhost:8080"
    OPENCTI_API_KEY: Optional[str] = None

    # Velociraptor settings
    VELOCIRAPTOR_URL: str = "http://localhost:8889"
    VELOCIRAPTOR_API_KEY: Optional[str] = None

    # Shuffle settings
    SHUFFLE_URL: str = "http://localhost:3001"
    SHUFFLE_API_KEY: Optional[str] = None

    class Config:
        env_file = ".env"

settings = Settings()
