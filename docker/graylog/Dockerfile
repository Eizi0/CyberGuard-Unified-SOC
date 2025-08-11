FROM graylog/graylog:5.1

# Configuration personnalisée
COPY config/graylog.conf /usr/share/graylog/data/config/graylog.conf

# Variables d'environnement par défaut
ENV GRAYLOG_HTTP_EXTERNAL_URI="http://localhost:9000/"
ENV GRAYLOG_ROOT_TIMEZONE="UTC"

# Exposition des ports
EXPOSE 9000 12201/udp 1514/udp

# Point d'entrée par défaut du conteneur Graylog
ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]
