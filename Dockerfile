FROM php:8.0.0-fpm
USER root
# Install system dependencies
RUN apt-get update && apt-get install -y git wget
RUN apt-get install -y librdkafka-dev
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxslt-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libonig-dev \
    libbz2-dev \
    libmcrypt-dev \
    libpng-dev \
    libgd-dev \
    libpq-dev \
    libxslt1-dev

RUN docker-php-ext-install zip

RUN wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar && \
    mv pickle.phar /usr/local/bin/pickle && \
    chmod +x /usr/local/bin/pickle

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

RUN pickle install rdkafka

# enable rdkafka extension manually in php.ini
RUN echo "extension=rdkafka.so" >> /usr/local/etc/php/conf.d/rdkafka.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www
