# Drupal on FrankenPHP

Run the popular [Drupal CMS](https://drupal.org) on top of [FrankenPHP](https://frankenphp.dev),
the modern app server for PHP.

## Getting Started

```console
git clone https://github.com/dunglas/frankenphp-drupal
cd frankenphp-drupal
docker compose pull --include-deps
docker compose up
```

Drupal is available on `https://localhost`.

During initial Drupal setup, use the following database configuration:

* Database type: MySQL, MariaDB, Percona Server, or equivalent 
* Database name: drupal
* Database username: root
* Database password: example
* ADVANCED OPTIONS; Database host: db

## Using PostgreSQL instead of MariaDB

1. Create a file named `postgres.Dockerfile` with this content:

  ```dockerfile
  FROM postgres
  
  COPY docker-entrypoint-initdb.d/init-pg_trgm-extension.sh /docker-entrypoint-initdb.d/init-pg_trgm-extension.sh
  ```
2. Replace the `db` service definition in the `compose.yaml` file by this one:

  ```yaml
  db:
      build:
      context: .
      dockerfile: postgres.Dockerfile
      environment:
      POSTGRES_PASSWORD: example
      restart: always
  ```
3. In the `Dockerfile`, replace `pdo_mysql` by `pdo_pgsql`
3. During initial Drupal setup, use the following database configuration:
  * Database type: PostgreSQL
  * Database name: postgres
  * Database username: postgres
  * Database password: example
  * ADVANCED OPTIONS; Database host: postgres

## Drupal issues to follow

- [#3437187 Add Caddyfile configuration](https://www.drupal.org/project/drupal/issues/3437187)
- [#2218651 [meta] Make Drupal compatible with persistent app servers like ReactPHP, PHP-PM, PHPFastCGI, FrankenPHP, Swoole](https://www.drupal.org/project/drupal/issues/2218651)
- [#3611621 [meta] Use memory cache instead of property caches](https://www.drupal.org/project/drupal/issues/3611621)
