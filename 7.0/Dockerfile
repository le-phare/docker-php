FROM php:7.0-fpm

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    locales \
    git \
    ssh \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    zlib1g-dev \
    libicu-dev \
    libpq-dev \
    libssh2-1-dev \
    libxml2-dev \
    libwebp-dev \
    libmagickwand-dev  \
  && rm -rf /var/lib/apt/lists/*

RUN dpkg-reconfigure -f noninteractive locales \
  && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
  && echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen \
  && locale-gen

# common extension
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-webp-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) intl mcrypt gd opcache mbstring zip pdo_pgsql pdo_mysql soap pgsql mysqli exif

# PECL modules
RUN pecl install imagick && docker-php-ext-enable imagick \
  && pecl install apcu && docker-php-ext-enable apcu \
  && pecl install apcu_bc && docker-php-ext-enable --ini-name=docker-php-ext-apcu_bc.ini apc \
  && pecl install ssh2-1.0 && docker-php-ext-enable ssh2 \
  && pecl install memcached && docker-php-ext-enable memcached

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

WORKDIR /var/www/symfony

# Config
COPY symfony.ini $PHP_INI_DIR/conf.d/
COPY symfony.pool.conf $PHP_INI_DIR/pool.d/
