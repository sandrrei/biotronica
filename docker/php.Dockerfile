FROM php:8.2-apache

# Install any additional PHP extensions or tools here if needed
# Example: install mysqli and pdo_mysql
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libicu-dev \
    libmagickwand-dev \
    unzip \
    git \
    curl \
    nano \
    && docker-php-ext-install zip intl \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80
