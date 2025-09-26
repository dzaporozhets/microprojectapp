#!/bin/bash
set -e

# Generate SECRET_KEY_BASE if it does not exist
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "SECRET_KEY_BASE=$(openssl rand -hex 64)" >> /rails/.env
  echo "SECRET_KEY_BASE generated and saved to .env"
else
  echo "SECRET_KEY_BASE already set, skipping generation."
fi

# Make sure to execute the main command after the script
exec "$@"
