ARG PHP_VERSION
ARG PHP_EXTENSIONS

FROM php:${PHP_VERSION}-fpm

WORKDIR /usr/local/etc/php/conf.d/
COPY --link symfony.ini .
WORKDIR /usr/local/etc/php/pool.d/
COPY --link symfony.pool.conf .

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions ${PHP_EXTENSIONS}

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony
