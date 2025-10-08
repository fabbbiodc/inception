#!/bin/sh

set -e

WEB_ROOT=/var/www/html

echo "Waiting for MariaDB to be ready..."
until nc -z mariadb 3306; do
    echo "MariaDB not ready yet, waiting..."
    sleep 1
done
echo "MariaDB is ready."

if wp core is-installed --allow-root --path=$WEB_ROOT; then
    echo "WordPress is already installed."
else
    echo "WordPress not found. Starting installation..."

    mkdir -p $WEB_ROOT
    cd $WEB_ROOT

    if ! wp core is-installed --allow-root; then
        php -d memory_limit=256M /usr/local/bin/wp core download --allow-root
    fi

    php -d memory_limit=256M /usr/local/bin/wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    php -d memory_limit=256M /usr/local/bin/wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    php -d memory_limit=256M /usr/local/bin/wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root

    echo "WordPress installation complete."
    chown -R nobody:nobody $WEB_ROOT
fi

echo "Starting PHP-FPM..."
exec "$@"