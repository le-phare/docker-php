# lephare/php Docker image

Pre-configured Docker image that follows [Le Phare](https://www.lephare.com) projects
[recommendations](https://faros.lephare.com)

## Included tools

- [Composer](https://getcomposer.org)
- [Symfony CLI](https://symfony.com/download) (latest release at build time), e.g. for `symfony lsp:check`.
  Its first run downloads the language tools into `$HOME/.config/symfony-cli`: mount this directory
  from the host so that each `docker compose run --rm` does not download them again.

## Supported versions

| Version | Supported until |
|---------|-----------------|
| 8.5     | 31 Dec. 2029    |
| 8.4     | 31 Dec. 2028    |
| 8.3     | 31 Dec. 2027    |
| 8.2     | 31 Dec. 2026    |

## Unsupported versions

| Version | Supported until |
|---------|-----------------|
| 8.1     | 31 Dec. 2025    |
| 8.0     | 12 Mar. 2024    |
| 7.4     | 14 Dec. 2023    |
| 7.3     | 14 Dec. 2022    |
| 7.2     | 14 Dec. 2022    |
| 7.1     | 03 Apr. 2021    |
| 7.0     | 03 Apr. 2021    |
| 5.6     | 03 Apr. 2021    |
| 5.4     | 03 Jul. 2020    |
