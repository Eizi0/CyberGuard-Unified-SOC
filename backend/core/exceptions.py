class IntegrationError(Exception):
    """Base exception for integration errors"""
    pass

class AuthenticationError(IntegrationError):
    """Exception raised for authentication failures"""
    pass

class ConnectionError(IntegrationError):
    """Exception raised for connection failures"""
    pass

class ConfigurationError(IntegrationError):
    """Exception raised for configuration errors"""
    pass

class APIError(IntegrationError):
    """Exception raised for API errors"""
    pass
