# Docker

**This guide is in development. There are might be mistakes.**

You can build and run the app with Docker. The app will be running on port `3000` by default.

## Dockerfile

- Dockerfile - for production env
- Dockerfile.dev - for development env

The database is not included here, so make sure to pass a `DATABASE_URL` to the container.

You can build the image yourself or use our container registry with pre-built images:

    docker run registry.gitlab.com/dzaporozhets/microprojectapp:main

Then run the app.

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

## Docker Compose

- docker-compose.dev.yml
- docker-compose.prod.yml

### Development Environment

The Docker Compose file includes Rails and a Postgres database. It is sufficient to get the application running and functional.

    # Run application
    docker-compose -f docker-compose.dev.yml up

    # Create database
    docker-compose -f docker-compose.dev.yml run web bundle exec rails db:setup

    # Compile assets (like CSS). We don't precompile assets in Dockerfile.dev
    docker-compose -f docker-compose.dev.yml run web bundle exec rails assets:precompile

### Production Environment

The Docker Compose file includes Rails, a Postgres database, and an Nginx web server.

Requirements:

1. Rails production environment requires HTTPS by default. We included Nginx in the compose file.
2. `SECRET_KEY_BASE` containing your secret key. You can generate one with `bin/rails secret` or with `bin/generate-env-vars`.


Now we can genereate certificate and run the application:


    # Generate SSL cert
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt -subj "/CN=localhost"

    # Run application
    SECRET_KEY_BASE=your_secret_key_base docker-compose -f docker-compose.prod.yml up

    # Create database
    SECRET_KEY_BASE=your_secret_key_base docker-compose -f docker-compose.prod.yml run web bundle exec rails db:setup


Open the app at https://localhost

#### Migrations

Once you have the app running, you need to run database migrations:

    SECRET_KEY_BASE=your_secret_key_base docker-compose -f docker-compose.prod.yml run web bundle exec rails db:setup

