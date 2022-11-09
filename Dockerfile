FROM dunglas/frankenphp:latest-alpine

# https://www.drupal.org/project/drupal/releases/10.0.0-beta2
ENV DRUPAL_VERSION=10.0.0-beta2 \
    APP_PATH=/app

RUN rm -rf ${APP_PATH} && \
    install-php-extensions \
    apcu \
    gd \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    zip

WORKDIR ${APP_PATH}

COPY composer.json ${APP_PATH}/

COPY --from=drupal /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/
COPY --from=composer/composer:2-bin /composer /usr/local/bin/

RUN set -eux; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	composer install --no-interaction --no-progress; \
	chown -R www-data:www-data ${APP_PATH}/public/sites ${APP_PATH}/public/modules ${APP_PATH}/public/themes; \
    cp ${APP_PATH}/public/sites/default/default.settings.php ${APP_PATH}/public/sites/default/settings.php; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"

ENV PATH=${PATH}:/app/vendor/bin

WORKDIR /app
