FROM postgres

COPY docker-entrypoint-initdb.d/init-pg_trgm-extension.sh /docker-entrypoint-initdb.d/init-pg_trgm-extension.sh
