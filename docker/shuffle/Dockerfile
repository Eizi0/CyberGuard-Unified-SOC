FROM ghcr.io/shuffle/shuffle:latest

# Configuration personnalisée
COPY config/shuffle-config.yaml /shuffle/.shuffle/config.yaml

# Variables d'environnement
ENV SHUFFLE_APP_HOTLOAD=true
ENV SHUFFLE_BASE_IMAGE_NAME=shuffle
ENV SHUFFLE_BASE_IMAGE_REGISTRY=ghcr.io
ENV SHUFFLE_BASE_IMAGE_TAG=latest

# Exposition des ports
EXPOSE 3443

# Volume pour les données persistantes
VOLUME ["/shuffle/data"]

# Commande par défaut
CMD ["/docker-entrypoint.sh"]
