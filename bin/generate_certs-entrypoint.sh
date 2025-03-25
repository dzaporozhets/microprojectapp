#!/bin/sh

set -e  # Stop execution on error

CERTS_DIR="/etc/nginx/certs"
CERT_KEY="$CERTS_DIR/nginx-selfsigned.key"
CERT_CRT="$CERTS_DIR/nginx-selfsigned.crt"

# Check if certificates already exist
if [ ! -f "$CERT_KEY" ] || [ ! -f "$CERT_CRT" ]; then
  mkdir -p "$CERTS_DIR"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_KEY" -out "$CERT_CRT" \
    -subj "/C=UA/ST=Kyiv/L=Kyiv/O=MyApp/OU=IT Department/CN=myapp.local"
  echo "SSL certificates generated successfully."
else
  echo "SSL certificates already exist."
fi
