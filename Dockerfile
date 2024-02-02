FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get install -y \
        software-properties-common \
        iputils-ping \
        vim \
        nano \
        procps \
        nginx && \
    rm /etc/nginx/sites-enabled/default

RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
        php8.3 \
        php8.3-fpm \
        php8.3-bz2 \
        php8.3-curl \
        php8.3-decimal \
        php8.3-dom \
        php8.3-gd \
        php8.3-intl \
        php8.3-mbstring \
        php8.3-mysql \
        php8.3-pgsql \
        php8.3-redis \
        php8.3-swoole \
        php8.3-xml \
        php8.3-zip

RUN ln -s /dev/stderr /var/log/php8.3-fpm.log && \
    rm -f /var/log/nginx/error.log && ln -s /dev/stderr /var/log/nginx/error.log

COPY entrypoint.sh /entrypoint.sh

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

ENTRYPOINT ["/entrypoint.sh"]
