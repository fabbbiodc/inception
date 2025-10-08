#!/bin/sh

set -e

CERT_FILE="${CRT_PATH}/inception.crt"
KEY_FILE="${KEY_PATH}/inception.key"

# Check if the certificate and key already exist
if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
    echo "TLS certificate and key already exist. Skipping generation."
else
    echo "Generating TLS certificate and key..."

    # Create directories if they don't exist
    mkdir -p "$CRT_PATH"
    mkdir -p "$KEY_PATH"

    # Generate the self-signed certificate
    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:4096 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/C=ES/ST=Catalonia/L=Barcelona/O=42/OU=student/CN=${DOMAIN_NAME}"
		
    echo "TLS certificate and key generated successfully."
fi

# Execute the main container command (passed as arguments)
exec "$@" # CHECK