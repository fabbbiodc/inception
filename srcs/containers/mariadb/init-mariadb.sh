#!/bin/sh

chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found. Initializing..."
    
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    /usr/bin/mysqld --user=mysql &
    
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    mariadb -u root << EOF
-- Drop the anonymous user and test database for security
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
-- Create the user and database if they don't exist
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
-- Set the root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
-- Reload the privileges to apply all changes immediately
FLUSH PRIVILEGES;
EOF

    mysqladmin shutdown
else
    echo "Database already initialized."
fi

exec /usr/bin/mysqld --user=mysql --bind-address=0.0.0.0