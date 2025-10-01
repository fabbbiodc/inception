#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found. Initializing..."
    
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    /usr/bin/mysqld --user=mysql &
    
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    mariadb -u root << EOF
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin shutdown
else
    echo "Database already initialized."
fi

exec /usr/bin/mysqld --user=mysql --bind-address=0.0.0.0
