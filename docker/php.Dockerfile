### php.Dockerfile
# This Dockerfile steps up a PHP environment with Apache for web applications.
# It includes necessary PHP extensions, sets up Apache, and configures PHP settings.
# The PHP version used is 8.2, and the working directory is set to /var/www/html.
FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libzip-dev libicu-dev libmagickwand-dev cron \
    unzip acl git curl nano net-tools curl inetutils-ping traceroute \
    && docker-php-ext-install zip intl \
    && pecl install imagick  \
    && docker-php-ext-enable imagick  \
    && apt-get clean

# Apache settings
RUN a2enmod rewrite
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf \
 && a2enconf servername

# Timezone and PHP configs
RUN echo "Europe/Lisbon" > /etc/timezone \
 && ln -snf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime \
 && echo "date.timezone = Europe/Lisbon" >> /usr/local/etc/php/php.ini \
 && echo "session.save_path = /var/www/html/sessions" >> /usr/local/etc/php/conf.d/session.ini \
 && echo "post_max_size=200M\nupload_max_filesize=200M" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "memory_limit=1G" > /usr/local/etc/php/conf.d/memory-limit.ini

# Create sessions folder and assign correct permissions
RUN mkdir -p /var/www/html/sessions

### install cron, but already part of build
#RUN apt-get update && apt-get install -y cron

# Copia o script de permissões para o container
COPY ./docker/fix-permissions.sh /usr/local/bin/fix-permissions.sh

# Torna o script executável
RUN chmod +x /usr/local/bin/fix-permissions.sh

# Cria ficheiro de log para o cron
RUN touch /var/log/cron.log

### 10 mts cron job to fix permissions
### RUN echo "*/10 * * * * root /usr/local/bin/fix-permissions.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/fix-perms \
# Configura cronjob para correr o script todos os dias às 3h da manhã
RUN echo "0 3 * * * root /usr/local/bin/fix-permissions.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/fix-perms && \
    chmod 0644 /etc/cron.d/fix-perms

# Garante que o cronjob seja reconhecido pelo cron
RUN crontab /etc/cron.d/fix-perms

# Ativa os serviços Apache e cron no arranque do container
CMD cron && apache2-foreground

WORKDIR /var/www/html

EXPOSE 80

