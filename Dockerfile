FROM dunglas/frankenphp:latest-alpine

RUN install-php-extensions \
    apcu \
    gd \
    opcache \
    pdo_pgsql \
    zip

COPY --from=drupal /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

COPY --from=composer/composer:2-bin /composer /usr/local/bin/

# https://www.drupal.org/project/drupal/releases/10.0.0-beta2
ENV DRUPAL_VERSION=10.0.0-beta2 \
    APP_PATH=/app

RUN set -eux; \
	rm -rf ${APP_PATH}; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	composer create-project --no-interaction --no-progress "drupal/recommended-project:${DRUPAL_VERSION}" ${APP_PATH}; \
	chown -R www-data:www-data ${APP_PATH}/web/sites ${APP_PATH}/web/modules ${APP_PATH}/web/themes; \
	ln -sf ${APP_PATH}/web ${APP_PATH}/public; \
    sed -i'' 's/public/web/' /etc/Caddyfile; \
    cp ${APP_PATH}/web/sites/default/default.settings.php ${APP_PATH}/web/sites/default/settings.php; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"

ENV PATH=${PATH}:/app/vendor/bin

WORKDIR /app
