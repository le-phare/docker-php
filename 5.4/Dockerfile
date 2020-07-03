FROM debian/eol:wheezy

ENV PHP_INI_DIR /etc/php5

RUN apt-get update \
    && apt-get install -y \
      locales curl git libxrender1 \
      php-apc php5-cli php5-common php5-curl php5-fpm php5-gd php5-imagick \
      php5-intl php5-mcrypt php5-mysql \
    && dpkg-reconfigure -f noninteractive  locales \
    && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
    && echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'Europe/Paris' | tee /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

EXPOSE 9000

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

WORKDIR /var/www/symfony

CMD usermod -u $DOCKER_USER_ID www-data && php5-fpm -F

COPY symfony.ini $PHP_INI_DIR/fpm/conf.d/
COPY symfony.ini $PHP_INI_DIR/cli/conf.d/
COPY symfony.pool.conf $PHP_INI_DIR/fpm/pool.d/
