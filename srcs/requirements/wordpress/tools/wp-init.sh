#!/bin/sh


echo "<h1>Static HTML Test Page</h1>" > /var/www/html/index.html

set -e

echo "Waiting for MariaDB to be ready..."
until nc -z mariadb 3306; do
    echo "MariaDB not ready yet, waiting..."
    sleep 2
done
echo "MariaDB is ready."

WEB_ROOT=/var/www/html

if [ -f "$WEB_ROOT/wp-config.php" ]; then
    echo "WordPress is already installed."
else
    echo "WordPress not found. Starting installation..."

    mkdir -p $WEB_ROOT
        cd $WEB_ROOT

    wp core download --allow-root

    wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    wp user create \
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