#!/bin/sh

set -e

# Define template and output file paths
TEMPLATE_FILE="/etc/nginx/http.d/default.conf.template"
OUTPUT_FILE="/etc/nginx/http.d/default.conf"

# Substitute environment variables in the template and create the final config file
# The 'export' command makes sure the variables are available to envsubst
export DOMAIN_NAME CRT_PATH KEY_PATH
envsubst '$DOMAIN_NAME $CRT_PATH $KEY_PATH' < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "/// [Nginx configuration generated]"

CERT_FILE="${CRT_PATH}/inception.crt"
KEY_FILE="${KEY_PATH}/inception.key"

if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
    echo "/// [TLS certificate and key already exist. Skipping generation]"
else
    echo "/// [Generating TLS certificate and key]"

    mkdir -p "$CRT_PATH"
    mkdir -p "$KEY_PATH"

    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:4096 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/C=ES/ST=Catalonia/L=Barcelona/O=42/OU=student/CN=${DOMAIN_NAME}"
		
    echo "/// [TLS certificate and key generated successfully]"
fi

echo "/// [Starting Nginx]"
exec "$@"