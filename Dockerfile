FROM dunglas/frankenphp:1-php8.3

# install mariadb client
RUN apt-get update && apt-get install --no-install-recommends -y \
    mariadb-client \
  && rm -rf /var/lib/apt/lists/*
 
RUN install-php-extensions \
    apcu \
    gd \
    opcache \
    pdo_mysql \
    zip

COPY --from=drupal:php8.3 /opt/drupal /opt/drupal
COPY --from=drupal:php8.3 /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

COPY --from=composer/composer:2-bin /composer /usr/local/bin/

# https://github.com/docker-library/drupal/pull/259
# https://github.com/moby/buildkit/issues/4503
# https://github.com/composer/composer/issues/11839
# https://github.com/composer/composer/issues/11854
# https://github.com/composer/composer/blob/94fe2945456df51e122a492b8d14ac4b54c1d2ce/src/Composer/Console/Application.php#L217-L218
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /opt/drupal
COPY Caddyfile /etc/caddy/Caddyfile
RUN set -eux; \
	chown -R www-data:www-data web/sites web/modules web/themes; \
	rm -rf /app/public; \
	ln -sf /opt/drupal/web /app/public; \
	echo "\$settings['trusted_host_patterns'] = ['^' . preg_quote(\$_SERVER['SERVER_NAME'] ?? 'localhost', '/') . '\$'];" >> /opt/drupal/web/sites/default/default.settings.php; \
	cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php

ENV PATH=${PATH}:/opt/drupal/vendor/bin
