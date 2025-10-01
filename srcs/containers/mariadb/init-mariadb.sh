#!/bin/sh

# Ensure the mysql user owns the data directory
chown -R mysql:mysql /var/lib/mysql

# Initialize the database if it hasn't been already
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found. Initializing..."

    # Use mysql_install_db and specify the user and data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start the server in bootstrap mode to perform initial setup
    /usr/bin/mysqld --user=mysql --bootstrap << EOF
-- These commands are run by the server on initial startup
USE mysql;
FLUSH PRIVILEGES;

-- Drop the anonymous user and test database for security
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

-- Create the user and database if they don't exist
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Set the root password and allow root from network (for debugging)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Reload the privileges to apply all changes immediately
FLUSH PRIVILEGES;
EOF
else
    echo "Database already initialized."
    
    # Even if database exists, ensure user permissions are correct
    /usr/bin/mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Ensure the user exists and has proper permissions
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Ensure root can connect from network for debugging
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF
fi

# Start the server in the foreground using the configuration file
exec /usr/bin/mysqld --defaults-file=/etc/my.cnf --user=mysql