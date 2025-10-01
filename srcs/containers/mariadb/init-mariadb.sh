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

-- Set the root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Reload the privileges to apply all changes immediately
FLUSH PRIVILEGES;
EOF
else
    echo "Database already initialized."
fi

# Start the server in the foreground and listen on all network interfaces
exec /usr/bin/mysqld --user=mysql --bind-address=0.0.0.0