variable "IMAGE_NAME" {
  default = "lephare/php"
}

variable "DEBIAN_LATEST_VERSION" {
  default = "trixie"
}

variable "PHP_LATEST_VERSION" {
  default = "8.5"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  args = {
    PHP_EXTENSIONS = "@composer apcu exif gd imagick intl memcached opcache pdo_mysql pdo_pgsql pgsql soap zip"
  }
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

target "php-8-2" {
  inherits = ["docker-metadata-action"]
  name = "php-8-2-${debian-version}"
  matrix = {
    debian-version = ["bullseye", "bookworm", "trixie"]
  }
  args = {
    DEBIAN_VERSION = debian-version
    PHP_TIMEZONE   = "Europe/Paris"
    PHP_VERSION    = "8.2"
  }
  tags = [
    "${IMAGE_NAME}:8.2-${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:8.2" : "",
  ]
}

target "php-8-3" {
  inherits = ["docker-metadata-action"]
  name = "php-8-3-${debian-version}"
  matrix = {
    debian-version = ["bullseye", "bookworm", "trixie"]
  }
  args = {
    DEBIAN_VERSION = debian-version
    PHP_TIMEZONE   = "Europe/Paris"
    PHP_VERSION    = "8.3"
  }
  tags = [
    "${IMAGE_NAME}:8.3-${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:8.3" : "",
  ]
}

target "php-8-4" {
  inherits = ["docker-metadata-action"]
  name = "php-8-4-${debian-version}"
  matrix = {
    debian-version = ["bullseye", "bookworm", "trixie"]
  }
  args = {
    DEBIAN_VERSION = debian-version
    PHP_TIMEZONE   = "UTC"
    PHP_VERSION    = "8.4"
  }
  tags = [
    "${IMAGE_NAME}:8.4-${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:8.4" : "",
  ]
}

target "php-8-5" {
  inherits = ["docker-metadata-action"]
  name = "php-8-5-${debian-version}"
  matrix = {
    debian-version = ["bookworm", "trixie"]
  }
  args = {
    DEBIAN_VERSION = debian-version
    PHP_TIMEZONE   = "UTC"
    PHP_VERSION    = "8.5"
  }
  tags = [
    "${IMAGE_NAME}:8.5-${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:8.5" : "",
    "${IMAGE_NAME}:8-${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:8" : "",
    "${IMAGE_NAME}:${debian-version}",
      debian-version == DEBIAN_LATEST_VERSION ? "${IMAGE_NAME}:latest" : ""
  ]
}
