ARG PHP_VERSION
ARG PHP_EXTENSIONS

FROM mlocati/php-extension-installer:2 as extension-installer
FROM php:${PHP_VERSION}-fpm as base
FROM base

WORKDIR /usr/local/etc/php
COPY --link symfony.ini ./conf.d/
COPY --link symfony.pool.conf ./pool.d/

COPY --from=extension-installer /usr/bin/install-php-extensions /usr/local/bin

RUN install-php-extensions "${PHP_EXTENSIONS}"

RUN usermod -u 1000 www-data && usermod -G staff www-data

WORKDIR /var/www/symfony
