from typing import Optional, List
from datetime import datetime
from .models import ChatboxConfig, ChatMessage, ChatResponse, ChatHistory
from .providers import get_provider
from ..database import Database
from ..config import Settings

class ChatboxService:
    """Service gérant les interactions avec le chatbox."""

    @staticmethod
    async def set_configuration(config: ChatboxConfig) -> dict:
        """Configure le provider IA."""
        # Valider la configuration
        provider = get_provider(config.provider)
        await provider.validate_api_key(config.api_key)

        # Sauvegarder en base de données
        query = """
        INSERT INTO chatbox_config 
        (provider, api_key, default_model, temperature, max_tokens, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, NOW(), NOW())
        ON CONFLICT (id) DO UPDATE SET
            provider = EXCLUDED.provider,
            api_key = EXCLUDED.api_key,
            default_model = EXCLUDED.default_model,
            temperature = EXCLUDED.temperature,
            max_tokens = EXCLUDED.max_tokens,
            updated_at = NOW()
        RETURNING id
        """
        async with Database.get_connection() as conn:
            result = await conn.fetchval(
                query,
                config.provider,
                config.api_key,
                config.default_model,
                config.temperature,
                config.max_tokens
            )

        return {"id": result, "status": "Configuration saved"}

    @staticmethod
    async def get_configuration() -> ChatboxConfig:
        """Récupère la configuration actuelle."""
        query = "SELECT * FROM chatbox_config ORDER BY created_at DESC LIMIT 1"
        async with Database.get_connection() as conn:
            row = await conn.fetchrow(query)
            if not row:
                return None
            return ChatboxConfig(
                provider=row['provider'],
                api_key=row['api_key'],
                default_model=row['default_model'],
                temperature=row['temperature'],
                max_tokens=row['max_tokens']
            )

    @staticmethod
    async def process_message(message: ChatMessage, user) -> ChatResponse:
        """Traite un message et retourne la réponse du chatbot."""
        # Récupérer la configuration
        config = await ChatboxService.get_configuration()
        if not config:
            raise ValueError("Chatbox not configured")

        # Obtenir le provider
        provider = get_provider(config.provider)
        provider.set_api_key(config.api_key)

        # Préparer les paramètres
        model = message.model or config.default_model
        temperature = message.temperature or config.temperature

        # Obtenir la réponse
        response = await provider.get_completion(
            message.message,
            model=model,
            temperature=temperature,
            max_tokens=config.max_tokens,
            context=message.context
        )

        # Sauvegarder dans l'historique
        await ChatboxService._save_to_history(
            user.id,
            message.message,
            response,
            model
        )

        return ChatResponse(
            message=response,
            model=model,
            created_at=datetime.now()
        )

    @staticmethod
    async def _save_to_history(
        user_id: int,
        message: str,
        response: str,
        model: str
    ):
        """Sauvegarde une conversation dans l'historique."""
        query = """
        INSERT INTO chatbox_history 
        (user_id, message, response, model, created_at)
        VALUES ($1, $2, $3, $4, NOW())
        """
        async with Database.get_connection() as conn:
            await conn.execute(
                query,
                user_id,
                message,
                response,
                model
            )

    @staticmethod
    async def get_history(user, limit: int = 50) -> List[ChatHistory]:
        """Récupère l'historique des conversations."""
        query = """
        SELECT * FROM chatbox_history
        WHERE user_id = $1
        ORDER BY created_at DESC
        LIMIT $2
        """
        async with Database.get_connection() as conn:
            rows = await conn.fetch(query, user.id, limit)
            return [ChatHistory(**row) for row in rows]

    @staticmethod
    async def clear_history() -> dict:
        """Efface l'historique des conversations."""
        query = "DELETE FROM chatbox_history"
        async with Database.get_connection() as conn:
            await conn.execute(query)
        return {"status": "History cleared"}
