#!/bin/sh

set -e

WEB_ROOT=/var/www/html

echo "Waiting for MariaDB to be ready..."
until nc -z mariadb 3306; do
    echo "MariaDB not ready yet, waiting..."
    sleep 1
done
echo "MariaDB is ready."

if [ -f "$WEB_ROOT/wp-config.php" ]; then
    echo "/// [WordPress is already configured]"
else
    echo "/// [WordPress not found. Starting installation]"

    DB_PASSWORD=$(cat /run/secrets/db_password)
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

    mkdir -p $WEB_ROOT
    cd $WEB_ROOT

    if [ ! -f "index.php" ]; then
        php83 -d memory_limit=256M /usr/local/bin/wp core download --allow-root
    fi

    php83 -d memory_limit=256M /usr/local/bin/wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass="$DB_PASSWORD" \
        --dbhost=mariadb \
        --allow-root

    php83 -d memory_limit=256M /usr/local/bin/wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    php83 -d memory_limit=256M /usr/local/bin/wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    echo "/// [WordPress installation complete]"
    chown -R nobody:nobody $WEB_ROOT
fi

if wp plugin is-installed redis-cache --allow-root; then
	echo "/// [Redis Cache already installed]"
else
	echo "/// [Installing Redis Cache]"

	wp plugin install redis-cache --activate --allow-root

	wp config set WP_REDIS_HOST "redis" --allow-root
	wp config set WP_REDIS_PORT "6379" --allow-root
	wp config set WP_REDIS_PREFIX "inception_" --allow-root

	wp redis enable --allow-root
fi

chown -R nobody:nobody $WEB_ROOT

echo "/// [Starting PHP-FPM]"
exec "$@"