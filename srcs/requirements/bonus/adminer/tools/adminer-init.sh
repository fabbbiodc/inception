#!/bin/sh

set -e

ADMINER_DIR="/var/www/html/adminer"
ADMINER_FILE="$ADMINER_DIR/index.php"

if [ ! -d "$ADMINER_DIR" ]; then
    echo "/// [Creating Adminer directory]"
    mkdir -p "$ADMINER_DIR"
fi

if [ ! -f "$ADMINER_FILE" ]; then
    echo "/// [Downloading Adminer]"
    curl -L "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -o "$ADMINER_FILE"
    chown -R nobody:nobody "$ADMINER_DIR"
    echo "/// [Adminer downloaded successfully]"
else
    echo "/// [Adminer already exists]"
fi

echo "/// [Starting PHP-FPM for Adminer]"

exec "$@"