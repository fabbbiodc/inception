#!/bin/sh

set -e

FTP_USER="${FTP_USER}"
FTP_PASSWORD="${FTP_PASSWORD}"

if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -h /var/www/html -s /bin/sh "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

exec "$@"