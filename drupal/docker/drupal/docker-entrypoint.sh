#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- frankenphp run "$@"
fi

if [ "$1" = 'frankenphp' ] || [ "$1" = 'drupal' ] || [ "$1" = 'drush' ]; then
    echo "hello"

    # ./vendor/drush/drush/drush site-install \
    #     --db-url=${DATABASE_URL} \
    #     --account-pass=${DRUPAL_ADMIN_PASSWORD} -y -v; \
fi

exec "$@"