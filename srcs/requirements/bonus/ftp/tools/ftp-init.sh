#!/bin/sh

set -e

FTP_USER_SECRET_PATH=/run/secrets/ftp_user
FTP_PASSWORD_SECRET_PATH=/run/secrets/ftp_password

if [ -f "$FTP_USER_SECRET_PATH" ] && [ -f "$FTP_PASSWORD_SECRET_PATH" ]; then
    FTP_USER=$(cat "$FTP_USER_SECRET_PATH")
    FTP_PASSWORD=$(cat "$FTP_PASSWORD_SECRET_PATH")

    if ! id -u "$FTP_USER" >/dev/null 2>&1; then
        adduser -D -h /var/www/html -s /bin/sh "$FTP_USER"
        echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    fi
else
    echo "FTP secrets not found. Exiting."
    exit 1
fi

exec "$@"