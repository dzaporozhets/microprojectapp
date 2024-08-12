# Docker

You can build and run the app with Docker. App will be running on port `3000` by default.

## Dockerfile

- Dockerfile - for production env
- Dockerfile.dev - for development env

The repository contains the `Dockerfile`. Database is not included there.
So make sure to pass a `DATABASE_URL` to the container.

You can build image yourself or use our container registry with build images:

```
docker run registry.gitlab.com/dzaporozhets/microprojectapp:main
```

The run the app.

```
# Running in production mode 
# 
# 1. DATABASE_URL is required. 
# 2. SECRET_KEY_BASE is required. 
# 3. HTTPS web server is required 
# 4. Volume (optional) for file uploads
#
docker run -p 3000:3000 \
  -e DATABASE_URL=REPLACE_WITH_YOUR_DATABASE_URL_HERE \
  -e SECRET_KEY_BASE=REPLACE_WITH_YOUR_SECRET_HERE \
  registry.gitlab.com/dzaporozhets/microprojectapp:main

# Example running locally (still requires nginx in front to handle https)
docker run -p 3000:3000 \
  -e DATABASE_URL=postgres://username@host.docker.internal:5432/mydatabase \
  -e SECRET_KEY_BASE=$(docker run --rm registry.gitlab.com/dzaporozhets/microprojectapp:main bin/rails secret) \
  registry.gitlab.com/dzaporozhets/microprojectapp:main
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
