#!/bin/sh

set -e

DATADIR="/var/lib/mysql"

# Always ensure the directory exists and has the right owner
chown -R mysql:mysql "$DATADIR"

# If the database directory is empty, initialize it
if [ ! -d "$DATADIR/mysql" ]; then
    echo "Database not found, initializing."
    mariadb-install-db --user=mysql --datadir="$DATADIR"

    # Start the server in the background to do the initial setup
    mariadbd --user=mysql &
    pid="$!"

    # Wait for the server to be ready
    echo "Waiting for MariaDB to start..."
    until mariadb-admin ping --silent; do
        sleep 1
    done
    echo "MariaDB is running."

    # --- Run the setup commands ONLY on first run ---
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
    DB_PASSWORD=$(cat /run/secrets/db_password)

    mariadb -u root <<-EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
        CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
        GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
        FLUSH PRIVILEGES;
EOF

    echo "Database permissions configured."

    # Stop the background server gracefully
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'MariaDB shutdown failed.'
        exit 1
    fi

    echo "Initialization complete."
fi

echo "Starting MariaDB server for connections..."

# exec the final command
exec "$@"