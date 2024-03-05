FROM php:7.4-fpm as base_php_74
FROM php:8.0-fpm as base_php_80
FROM php:8.1-fpm as base_php_81
FROM php:8.2-fpm as base_php_82
FROM php:8.3-fpm as base_php_83

FROM scratch as config
WORKDIR /usr/local/etc/php/conf.d/
COPY --link symfony.ini .
WORKDIR /usr/local/etc/php/pool.d/
COPY --link symfony.pool.conf .

FROM base_php_74 as php_74
COPY --from=config / /

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer apcu exif gd imagick intl memcached opcache pdo_pgsql pgsql soap xdebug zip

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony

FROM base_php_80 as php_80
COPY --from=config / /

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer apcu exif gd imagick intl memcached opcache pdo_pgsql pgsql soap xdebug zip

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony

FROM base_php_81 as php_81
COPY --from=config / /

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer apcu exif gd imagick intl memcached opcache pdo_pgsql pgsql soap xdebug zip

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony

FROM base_php_82 as php_82
COPY --from=config / /

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer apcu exif gd imagick intl memcached opcache pdo_pgsql pgsql soap xdebug zip

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony

FROM base_php_83 as php_83
COPY --from=config / /

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer apcu exif gd imagick intl memcached opcache pdo_pgsql pgsql soap xdebug zip

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony
