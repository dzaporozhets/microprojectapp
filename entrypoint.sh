#!/bin/bash

# Exit on error
set -e

# Check if RAILS_MASTER_KEY is passed
if [ -z "$RAILS_MASTER_KEY" ]; then
  echo "⚠️  RAILS_MASTER_KEY не найден, генерируем новый..."
  export RAILS_MASTER_KEY=$(openssl rand -hex 32) #Generate a random key
  echo "🔑 Новый RAILS_MASTER_KEY: $RAILS_MASTER_KEY"
fi

# Run the standard container command
exec "$@"