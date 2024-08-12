# Docker

You can build and run the app with Docker. App will be running on port `3000` by default.

## Dockerfile

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

The repository contains `docker-compose.yml`. It includes Rails and Postgres database.
Its enough to get application running and function.

```
docker-compose up --build
```

Once you have the app running, you need to run database migrations:

```
docker-compose run web bundle exec rake db:migrate
```

## Production env

If you plan to use it for production then make sure to change next things in `docker-compose.yml`:

1. Change `RAILS_ENV` to `production`
2. Replace `SECRET_KEY_BASE_DUMMY` with `SECRET_KEY_BASE` containing your secret key. You can generate one with `bin/rails secret`.
3. Rails production environment requires https by default

