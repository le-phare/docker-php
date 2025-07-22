# syntax=docker/dockerfile:1
# check=error=true

ARG PHP_VERSION=8.4

FROM mlocati/php-extension-installer:2 AS extension-installer
FROM php:${PHP_VERSION}-fpm AS base
FROM base
ARG PHP_EXTENSIONS
ARG PHP_TIMEZONE=UTC

WORKDIR /usr/local/etc/php
COPY --link symfony.ini ./conf.d/

# override symfony.ini timezone placeholder
RUN sed -i "s@PHP_TIMEZONE@${PHP_TIMEZONE}@g" /usr/local/etc/php/conf.d/symfony.ini

COPY --link symfony.pool.conf ./pool.d/

COPY --from=extension-installer /usr/bin/install-php-extensions /usr/local/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    git=1:2.* \
    && rm -rf /var/lib/apt/lists/*

RUN install-php-extensions ${PHP_EXTENSIONS}

RUN usermod -u 1000 www-data && usermod -G staff www-data

WORKDIR /var/www/symfony
