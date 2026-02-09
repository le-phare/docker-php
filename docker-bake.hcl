variable "IMAGE_NAME" {
  default = "lephare/php"
}

variable "DEBIAN_VERSIONS" {
  default = "bookworm,trixie"
}

variable "LATEST_DEBIAN_VERSION" {
  default = "trixie"
}

variable "PHP_VERSIONS" {
  default = "8.4,8.5"
}

variable "LATEST_PHP_VERSION" {
  default = "8.5"
}

target "default" {
  matrix = {
    debian-version = split(",", DEBIAN_VERSIONS)
    php-version = split(",", PHP_VERSIONS)
  }
  name = "image-local-${replace(php-version, ".", "-")}-${debian-version}"
  inherits = ["image-${replace(php-version, ".", "-")}-${debian-version}"]
  output = ["type=docker"]
}

target "image" {
  matrix = {
    debian-version = split(",", DEBIAN_VERSIONS)
    php-version = split(",", PHP_VERSIONS)
  }
  name = "image-${replace(php-version, ".", "-")}-${debian-version}"
  args = {
    DEBIAN_VERSION = debian-version
    PHP_EXTENSIONS = "@composer apcu exif gd imagick intl memcached opcache pdo_mysql pdo_pgsql pgsql soap zip"
    PHP_TIMEZONE   = php-version == "8.2" || php-version == "8.3" ? "Europe/Paris" : "UTC"
    PHP_VERSION    = php-version
  }
  tags = [
    "${IMAGE_NAME}:${php-version}-${debian-version}",
      php-version == LATEST_PHP_VERSION ? "${IMAGE_NAME}:${debian-version}" : "",
      debian-version == LATEST_DEBIAN_VERSION ? "${IMAGE_NAME}:${php-version}" : "",
      debian-version == LATEST_DEBIAN_VERSION && php-version == LATEST_PHP_VERSION ? "${IMAGE_NAME}:latest" : ""
  ]
}

target "image-all" {
  matrix = {
    debian-version = split(",", DEBIAN_VERSIONS)
    php-version = split(",", PHP_VERSIONS)
  }
  name = "image-all-${replace(php-version, ".", "-")}-${debian-version}"
  inherits = ["image-${replace(php-version, ".", "-")}-${debian-version}"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
