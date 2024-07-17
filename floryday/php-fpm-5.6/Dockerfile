FROM php:5.6-fpm-alpine

# Zip
RUN apk add --update --no-cache libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/cache/apk/*

# Intl
RUN apk add --update --no-cache libintl icu icu-dev \
    && docker-php-ext-install intl \
    && rm -rf /var/cache/apk/*

# Iconv
RUN docker-php-ext-install iconv \
    && rm -rf /var/cache/apk/*

# GD
RUN apk add --update --no-cache freetype-dev  libjpeg-turbo-dev libpng-dev \
   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install -j$(nproc) gd \
   && rm -rf /var/cache/apk/*

# Mysql PDO
RUN docker-php-ext-install mysql pdo_mysql\
   && rm -rf /var/cache/apk/*

# Redis
RUN apk add --update --no-cache $PHPIZE_DEPS
#RUN pecl install -o -f redis && docker-php-ext-enable redis
RUN pecl install -o -f memcache && docker-php-ext-enable memcache \
   && apk del $PHPIZE_DEPS \
   && rm -rf /var/cache/apk/*

# git
RUN apk add --update --no-cache git \
    && rm -rf /var/cache/apk/*

# Composer
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer \
    && composer self-update --no-plugins \
    && composer config --no-plugins --global github-oauth.github.com "6d57e9001a3e6ce8ad93a06dd84d041e85f1d6cc" \
    && composer global --no-plugins require "fxp/composer-asset-plugin:^1.3.1" \
    && rm -rf /var/cache/apk/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN chmod -R 777 /var/log

RUN apk add busybox-extras

ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached-2.2.0 \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

WORKDIR /var/www/web
VOLUME  ["/var/www/web"]
