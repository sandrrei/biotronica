FROM codercom/code-server:latest

USER root

# Instala cron e acl
RUN apt-get update && \
    apt-get install -y cron acl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copia o script
COPY ./docker/fix-permissions.sh /usr/local/bin/fix-permissions.sh
RUN chmod +x /usr/local/bin/fix-permissions.sh

# Cria log e cronjob
RUN touch /var/log/cron.log && \
    echo "0 3 * * * root /usr/local/bin/fix-permissions.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/fix-perms && \
    chmod 0644 /etc/cron.d/fix-perms && \
    crontab /etc/cron.d/fix-perms

# Arranca cron + VSCode
CMD service cron start && /usr/bin/entrypoint.sh
