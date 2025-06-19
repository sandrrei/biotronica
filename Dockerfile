FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y \
    curl gnupg \
    libzip-dev zip \
    libmagickwand-dev \
    libicu-dev \
    nano \
    vim && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v && \
    pecl install imagick && \
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
