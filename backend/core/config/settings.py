from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    # Application Settings
    APP_NAME: str = "CyberGuard Unified SOC"
    VERSION: str = "1.0.0"
    DEBUG: bool = True
    API_PREFIX: str = "/api"
    SECRET_KEY: str = "your-secret-key-here"
    
    # CORS Settings
    CORS_ORIGINS: List[str] = ["http://localhost:3000"]
    
    # Database Settings
    MONGODB_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "cyberguard"
    
    # Wazuh Settings
    WAZUH_HOST: str = "http://wazuh.manager:55000"
    WAZUH_USERNAME: str = "wazuh"
    WAZUH_PASSWORD: str = "wazuh"
    
    # Graylog Settings
    GRAYLOG_HOST: str = "http://graylog:9000"
    GRAYLOG_USERNAME: str = "admin"
    GRAYLOG_PASSWORD: str = "admin"
    
    # TheHive Settings
    THEHIVE_HOST: str = "http://thehive:9001"
    THEHIVE_API_KEY: str = "your-api-key-here"
    
    # MISP Settings
    MISP_HOST: str = "http://misp"
    MISP_API_KEY: str = "your-api-key-here"
    
    # OpenCTI Settings
    OPENCTI_HOST: str = "http://opencti:8080"
    OPENCTI_API_KEY: str = "your-api-key-here"
    
    # Velociraptor Settings
    VELOCIRAPTOR_HOST: str = "http://velociraptor:8889"
    VELOCIRAPTOR_API_KEY: str = "your-api-key-here"
    
    # Shuffle Settings
    SHUFFLE_HOST: str = "http://shuffle:3443"
    SHUFFLE_API_KEY: str = "your-api-key-here"
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
