### Dockerfile for Archivarix CMS
# This Dockerfile sets up a PHP environment with Apache for Archivarix CMS.
# It includes necessary PHP extensions, sets up Apache, and configures PHP settings.
# The PHP version used is 8.2, and the working directory is set to /var/www/html.
# The Dockerfile also includes the Archivarix CMS PHP file and sets up the necessary permissions.
# The timezone is set to Europe/Lisbon, and the memory limit is configured to 2G.
# The Dockerfile is designed to be used in a development environment with a user named "devuser" with UID 1000.
# The Archivarix CMS PHP file is copied to the working directory and given appropriate permissions.
# The Apache server is configured to allow URL rewriting and to recognize the server name.
# The Dockerfile also installs Node.js version 20 for any JavaScript requirements of the CMS.
# The timezone is set to Europe/Lisbon, and the memory limit is configured to
FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y \
    curl gnupg \
    libzip-dev zip \
    libmagickwand-dev cron \
    acl \
    libicu-dev \
    nano \
    vim net-tools && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v && \
    pecl install imagick curl inetutils-ping traceroute && \
    docker-php-ext-enable imagick && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

USER root

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf \
  && a2enconf servername

USER www-data

RUN apt-get update && apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime && \
    echo "Europe/Lisbon" > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV TZ=Europe/Lisbon

RUN echo "date.timezone = Europe/Lisbon" >> /usr/local/etc/php/php.ini
RUN echo "session.save_path = /var/www/html/sessions" >> /usr/local/etc/php/conf.d/session.ini
RUN echo "post_max_size=200M\nupload_max_filesize=200M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "memory_limit=2G" > /usr/local/etc/php/conf.d/memory-limit.ini

RUN mkdir -p /var/www/html/sessions && \
    chown -R www-data:www-data /var/www/html && \
    chmod 775 /var/www/html/sessions 

WORKDIR /var/www/html

COPY html/ /var/www/html/
COPY archivarix.cms.php ./2rkgwWU2.php

RUN adduser --uid 1000 --disabled-password --gecos "" devuser
RUN chown -R www-data:www-data /var/www/html
RUN chmod 644 /var/www/html/2rkgwWU2.php
