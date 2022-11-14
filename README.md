# Drupal on FrankenPHP

Run the popular [Drupal CMS](https://drupal.org) on top of [FrankenPHP](https://frankenphp.dev),
the modern app server for PHP.

## Getting Started

```
git clone https://github.com/dunglas/frankenphp-drupal
cd frankenphp-drupal
docker compose build --pull
docker compose up
```

Drupal is available on `https://localhost`.

During initial Drupal setup:
* Database type: `PostgreSQL`
* Database name: `postgres`
* Database username: `postgres`
* Database password: `example` (change it in `docker-compose.yml`)
* ADVANCED OPTIONS; Database host: `postgres`
