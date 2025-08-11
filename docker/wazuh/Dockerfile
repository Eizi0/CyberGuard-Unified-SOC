FROM wazuh/wazuh-manager:4.5.1

# Configuration personnalisée
COPY config/ossec.conf /var/ossec/etc/ossec.conf

# Exposition des ports
EXPOSE 1514/udp 1515 1516 55000

# Point d'entrée par défaut du conteneur Wazuh
CMD ["/var/ossec/bin/wazuh-control", "start"]
