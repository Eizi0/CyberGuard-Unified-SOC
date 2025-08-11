FROM coolacid/misp-docker:core-latest

# Configuration personnalisée
COPY config/config.php /var/www/MISP/app/Config/config.php

# Variables d'environnement
ENV MYSQL_HOST=db
ENV MYSQL_DATABASE=misp
ENV REDIS_HOST=redis

# Exposition du port
EXPOSE 80 443

# Commande par défaut
CMD ["/entrypoint.sh"]
