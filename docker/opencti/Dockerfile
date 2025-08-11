FROM opencti/platform:5.8.2

# Configuration personnalisée
COPY config/production.json /opt/opencti/config/production.json

# Variables d'environnement
ENV NODE_OPTIONS=--max-old-space-size=8096
ENV APP__PORT=8080
ENV APP__ADMIN__EMAIL=admin@opencti.io
ENV APP__ADMIN__PASSWORD=admin
ENV APP__ADMIN__TOKEN=admin

# Exposition du port
EXPOSE 8080

# Commande par défaut
CMD ["./entrypoint.sh"]
