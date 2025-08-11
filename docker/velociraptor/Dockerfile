FROM velocidex/velociraptor:0.6.9

# Configuration personnalisée
COPY config/server.config.yaml /etc/velociraptor/server.config.yaml

# Exposition des ports
EXPOSE 8889 8000

# Volume pour les données persistantes
VOLUME ["/opt/velociraptor/data"]

# Commande par défaut
CMD ["/velociraptor", "--config", "/etc/velociraptor/server.config.yaml", "frontend"]
