from typing import Dict
from .base import BaseProvider
from .openai import OpenAIProvider
from .anthropic import AnthropicProvider

_PROVIDERS: Dict[str, BaseProvider] = {
    "openai": OpenAIProvider(),
    "anthropic": AnthropicProvider()
}

def get_provider(provider_name: str) -> BaseProvider:
    """Récupère une instance du provider demandé."""
    provider = _PROVIDERS.get(provider_name.lower())
    if not provider:
        raise ValueError(f"Unknown provider: {provider_name}")
    return provider
