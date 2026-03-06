# syntax=docker/dockerfile:1
# check=error=true

ARG DEBIAN_VERSION=trixie
ARG PHP_VERSION=8.5

FROM php:${PHP_VERSION}-fpm-${DEBIAN_VERSION}

ARG PHP_EXTENSIONS
ARG PHP_TIMEZONE=UTC

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

COPY --link symfony.ini /usr/local/etc/php/conf.d/

COPY --link symfony.pool.conf /usr/local/etc/php/pool.d/

# Override symfony.ini timezone placeholder
# PHP GD AVIF support on Debian Bullseye requires compiling libaom, downloaded from Google servers which are bugged at the moment, so we disable it with IPE_GD_WITHOUTAVIF=1
RUN sed -i "s@PHP_TIMEZONE@${PHP_TIMEZONE}@g" /usr/local/etc/php/conf.d/symfony.ini \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends git \
    && IPE_GD_WITHOUTAVIF=1 install-php-extensions ${PHP_EXTENSIONS} \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -u 1000 -G staff www-data \
    && groupmod -g 1000 www-data

WORKDIR /var/www/symfony
