from abc import ABC, abstractmethod
from typing import Optional

class BaseProvider(ABC):
    """Classe de base pour les providers d'IA."""

    def __init__(self):
        self.api_key = None

    def set_api_key(self, api_key: str):
        """Configure la clé API."""
        self.api_key = api_key

    @abstractmethod
    async def validate_api_key(self, api_key: str) -> bool:
        """Valide une clé API."""
        pass

    @abstractmethod
    async def get_completion(
        self,
        prompt: str,
        model: str,
        temperature: float,
        max_tokens: int,
        context: Optional[str] = None
    ) -> str:
        """Obtient une completion du modèle."""
        pass

    @abstractmethod
    async def get_available_models(self) -> list:
        """Récupère la liste des modèles disponibles."""
        pass
