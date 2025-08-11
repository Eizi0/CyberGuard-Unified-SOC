FROM thehiveproject/thehive4:4.1.19

# Configuration personnalisée
COPY config/application.conf /etc/thehive/application.conf

# Variables d'environnement
ENV JVM_OPTS="-Xms1024M -Xmx2048M"

# Exposition du port
EXPOSE 9000

# Point d'entrée par défaut
CMD ["/opt/thehive/bin/thehive", "-Dconfig.file=/etc/thehive/application.conf"]
