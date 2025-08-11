from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
from .models import ChatboxConfig, ChatMessage, ChatResponse
from .services import ChatboxService
from ..auth import get_current_user

router = APIRouter(prefix="/chatbox", tags=["chatbox"])

@router.post("/config")
async def set_configuration(
    config: ChatboxConfig,
    current_user = Depends(get_current_user)
):
    """Configure le provider IA et ses paramètres."""
    if not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Admin access required")
    
    return await ChatboxService.set_configuration(config)

@router.get("/config")
async def get_configuration(
    current_user = Depends(get_current_user)
):
    """Récupère la configuration actuelle."""
    return await ChatboxService.get_configuration()

@router.post("/chat")
async def chat(
    message: ChatMessage,
    current_user = Depends(get_current_user)
):
    """Envoie un message au chatbot et reçoit une réponse."""
    return await ChatboxService.process_message(message, current_user)

@router.get("/history")
async def get_history(
    limit: Optional[int] = 50,
    current_user = Depends(get_current_user)
):
    """Récupère l'historique des conversations."""
    return await ChatboxService.get_history(current_user, limit)

@router.delete("/history")
async def clear_history(
    current_user = Depends(get_current_user)
):
    """Efface l'historique des conversations."""
    if not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Admin access required")
    
    return await ChatboxService.clear_history()
