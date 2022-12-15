# ----------------------
# Drupal on Dunglas FrankenPHP
# ----------------------
FROM dunglas/frankenphp AS app_drupal

ARG DRUPAL_PROJECT
ENV DRUPAL_PROJECT ${DRUPAL_PROJECT}

ARG DRUPAL_VERSION
ENV DRUPAL_VERSION ${DRUPAL_VERSION}

RUN install-php-extensions \
    apcu \
    gd \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    zip

COPY --from=drupal /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

COPY --from=composer/composer:2-bin /composer /usr/local/bin/

WORKDIR /opt/drupal

# Copy from the official image when Drupal 10.0 will be released
RUN set -eux; \
    export COMPOSER_HOME="$(mktemp -d)"; \
    composer create-project --no-interaction "${DRUPAL_PROJECT}:${DRUPAL_VERSION}" ./; \
    chown -R www-data:www-data web/sites web/modules web/themes; \
    rm -rf /app/public; \
    ln -sf /opt/drupal/web /app/public; \
    sed -i'' 's/public/web/' /etc/Caddyfile; \
    cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php; \
    # delete composer cache
    rm -rf "$COMPOSER_HOME"

ENV PATH=${PATH}:/opt/drupal/vendor/bin

# COPY docker/drupal/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
# RUN chmod +x /usr/local/bin/docker-entrypoint

# ENTRYPOINT ["docker-entrypoint"]
# CMD ["frankenphp", "run"]

# ----------------------
# PostgreSQL Database
# ----------------------

ARG POSTGRES_VERSION
ENV POSTGRES_VERSION ${POSTGRES_VERSION}

FROM postgres:14 AS app_database

COPY docker/postgres/init-pg_trgm-extension.sh /docker-entrypoint-initdb.d/init-pg_trgm-extension.sh
