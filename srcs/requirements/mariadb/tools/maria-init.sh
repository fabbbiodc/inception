#!/bin/sh

set -e

DATADIR="/var/lib/mysql"

chown -R mysql:mysql "$DATADIR"

if [ -d "$DATADIR/mysql" ]; then
	echo "Database already initialized."
else
	echo "Database not found, initializing."

	DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
	DB_PASSWORD=$(cat /run/secrets/db_password)

	mariadb-install-db --user=mysql --datadir="$DATADIR"
	mariadbd --user=mysql --datadir="$DATADIR" --bind-address=0.0.0.0 --port=3306 & pid="$!"

	for i in {30..0}; do
		if mariadb-admin ping -h"localhost" --silent; then
			break
		fi
		echo 'MariaDB starting...'
		sleep 1
	done

	if [ "$i" -eq 0 ]; then
		echo >&2 'MariaDB startup failed.'
		exit 1
	fi

	mariadb -u root <<-EOF
		CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
		CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
		GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
		FLUSH PRIVILEGES;
	EOF

	if ! kill -s TERM "$pid" || ! wait "$pid"; then
		echo >&2 'MariaDB shutdown failed.'
		exit 1
	fi
	
	echo "Database initialization complete."
fi

echo "Starting MariaDB server for connections..."

exec "$@"