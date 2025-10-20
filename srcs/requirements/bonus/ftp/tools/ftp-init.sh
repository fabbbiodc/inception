#!/bin/sh

set -e

FTP_USER="${FTP_USER}"
FTP_PASSWORD="${FTP_PASSWORD}"

if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -h /var/www/html -s /bin/sh "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
	addgroup "$FTP_USER" nobody
	chown -R "$FTP_USER":nobody /var/www/html
	chmod -R 775 /var/www/html
fi

exec "$@"