FROM php:8-fpm

RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    iputils-ping \
    vim \
    nano \
    libpq-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg  \
    && docker-php-ext-install -j$(nproc) gd pcntl pgsql pdo_pgsql pdo zip

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /app
