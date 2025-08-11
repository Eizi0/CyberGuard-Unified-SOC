from typing import Optional
import openai
from .base import BaseProvider

class OpenAIProvider(BaseProvider):
    """Provider pour OpenAI."""

    async def validate_api_key(self, api_key: str) -> bool:
        """Valide une clé API OpenAI."""
        try:
            openai.api_key = api_key
            await openai.ChatCompletion.acreate(
                model="gpt-3.5-turbo",
                messages=[{"role": "user", "content": "test"}],
                max_tokens=5
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
        """Obtient une completion d'OpenAI."""
        if not self.api_key:
            raise ValueError("API key not set")

        openai.api_key = self.api_key
        
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

        response = await openai.ChatCompletion.acreate(
            model=model,
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens
        )

        return response.choices[0].message.content

    async def get_available_models(self) -> list:
        """Récupère la liste des modèles OpenAI disponibles."""
        if not self.api_key:
            raise ValueError("API key not set")

        openai.api_key = self.api_key
        models = await openai.Model.alist()
        
        # Filtrer pour ne garder que les modèles GPT
        gpt_models = [
            model.id for model in models.data
            if "gpt" in model.id.lower()
        ]
        
        return gpt_models
