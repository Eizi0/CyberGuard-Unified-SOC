from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class ChatboxConfig(BaseModel):
    """Configuration du chatbox."""
    provider: str
    api_key: str
    default_model: str
    temperature: float = 0.7
    max_tokens: int = 2000

class ChatMessage(BaseModel):
    """Message envoyé au chatbot."""
    message: str
    context: Optional[str] = None
    model: Optional[str] = None
    temperature: Optional[float] = None

class ChatResponse(BaseModel):
    """Réponse du chatbot."""
    message: str
    model: str
    created_at: datetime

class ChatHistory(BaseModel):
    """Entrée d'historique des conversations."""
    id: int
    user_id: int
    message: str
    response: str
    model: str
    created_at: datetime

class ChatboxStats(BaseModel):
    """Statistiques d'utilisation du chatbox."""
    total_messages: int
    total_tokens: int
    average_response_time: float
