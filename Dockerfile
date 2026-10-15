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

ARG TARGETARCH

# Installed directly: `symfony lsp:check` would download it at runtime into $HOME
RUN set -eux; \
    case "${TARGETARCH}" in amd64) arch=x64 ;; arm64) arch=arm64 ;; *) exit 1 ;; esac; \
    release_url=https://github.com/symfony/language-tools/releases; \
    version="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "${release_url}/latest")"; \
    version="${version##*/}"; \
    asset="symfony-lsp-${version}-linux-${arch}"; \
    cd /tmp; \
    curl -fsSLO "${release_url}/download/${version}/${asset}.tar.gz"; \
    curl -fsSLO "${release_url}/download/${version}/SHA256SUMS"; \
    grep " ${asset}.tar.gz\$" SHA256SUMS | sha256sum -c -; \
    tar -xzf "${asset}.tar.gz" -C /usr/local/bin --strip-components=1 "${asset}/symfony-lsp"; \
    rm "${asset}.tar.gz" SHA256SUMS; \
    symfony-lsp --version

WORKDIR /var/www/symfony
