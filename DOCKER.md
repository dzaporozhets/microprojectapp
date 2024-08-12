# Docker

You can build and run the app with Docker. App will be running on port `3000` by default.

## Dockerfile

- Dockerfile - for production env
- Dockerfile.dev - for development env

The repository contains the `Dockerfile`. Database is not included there.
So make sure to pass a `DATABASE_URL` to the container.

You can find build docker images at the following address:

```
docker run registry.gitlab.com/dzaporozhets/microprojectapp:main
```

## Docker compose

- docker-compose.dev.yml
- docker-compose.prod.yml

Docker compose file includes Rails and Postgres database.
Its enough to get application running and function.

### Development

```
# Run application
docker-compose -f docker-compose.dev.yml up

# Create database
docker-compose -f docker-compose.dev.yml run web bundle exec rails db:setup

# Compile assets (like css). We don't precompile assets in Dockerfile.dev
docker-compose -f docker-compose.dev.yml run web bundle exec rails assets:precompile
```

### Production

Requirements:

1. Rails production environment requires https by default
1. `SECRET_KEY_BASE` containing your secret key. You can generate one with `bin/rails secret`.

```
# Generate ssl cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt -subj "/CN=localhost"

# Run application
SECRET_KEY_BASE=your_secret_key_base docker-compose -f docker-compose.prod.yml up

# Create database
SECRET_KEY_BASE=your_secret_key_base  docker-compose -f docker-compose.prod.yml run web bundle exec rails db:setup
```

Open app at https://localhost

#### Migrations

Once you have the app running, you need to run database migrations:

```
SECRET_KEY_BASE=your_secret_key_base  docker-compose -f docker-compose.prod.yml run web bundle exec rails db:setup
```
