from typing import Optional
import anthropic
from .base import BaseProvider

class AnthropicProvider(BaseProvider):
    """Provider pour Anthropic."""

    async def validate_api_key(self, api_key: str) -> bool:
        """Valide une clé API Anthropic."""
        try:
            client = anthropic.Client(api_key=api_key)
            client.messages.create(
                model="claude-instant-1",
                max_tokens=5,
                messages=[{"role": "user", "content": "test"}]
            )
            return True
        except:
            return False

    async def get_completion(
        self,
        prompt: str,
        model: str,
        temperature: float,
        max_tokens: int,
        context: Optional[str] = None
    ) -> str:
        """Obtient une completion d'Anthropic."""
        if not self.api_key:
            raise ValueError("API key not set")

        client = anthropic.Client(api_key=self.api_key)

        messages = []
        if context:
            messages.append({
                "role": "system",
                "content": context
            })
        
        messages.append({
            "role": "user",
            "content": prompt
        })

        response = client.messages.create(
            model=model,
            max_tokens=max_tokens,
            temperature=temperature,
            messages=messages
        )

        return response.content[0].text

    async def get_available_models(self) -> list:
        """Récupère la liste des modèles Anthropic disponibles."""
        return [
            "claude-2",
            "claude-instant-1"
        ]
