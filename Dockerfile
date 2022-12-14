FROM dunglas/frankenphp

RUN install-php-extensions \
    apcu \
    gd \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    zip

COPY --from=drupal /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

COPY --from=composer/composer:2-bin /composer /usr/local/bin/

# https://www.drupal.org/project/drupal/releases/10.0.0-rc3
ENV DRUPAL_VERSION 10.0.0-rc3

WORKDIR /opt/drupal
# Copy from the official image when Drupal 10.0 will be released
RUN set -eux; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" ./; \
	chown -R www-data:www-data web/sites web/modules web/themes; \
	rm -rf /app/public; \
	ln -sf /opt/drupal/web /app/public; \
    sed -i'' 's/public/web/' /etc/Caddyfile; \
    cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"

ENV PATH=${PATH}:/opt/drupal/vendor/bin
