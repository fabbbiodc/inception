#!/bin/sh

while ! mariadb -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} --silent; do
	echo "Initializing MariaDB"
	sleep 2
done

if [ -f /var/www/html/wp-config.php ]; then
    echo "WordPress already there"
else
    echo "Configuring WordPress..."
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    cd /var/www/html
    wp core download --allow-root

    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --path='/var/www/html'

    wp core install --allow-root \
        --url=fdi-cecc.42.fr \
        --title="Inception" \
        --admin_user=fdi-cecc \
        --admin_password=${MYSQL_PASSWORD} \
        --admin_email=fdi-cecc@student.42barcelona.com

    wp user create --allow-root \
        seconduser \
        seconduser@example.com \
        --role=author \
        --user_pass=anotherpassword
fi

echo "WordPress ready - Starting php"
exec php-fpm82 -F