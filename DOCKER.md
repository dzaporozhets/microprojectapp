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

#### Development

```
docker-compose -f docker-compose.dev.yml up
```

#### Production

```
docker-compose -f docker-compose.prod.yml up
```

#### Migrations

Once you have the app running, you need to run database migrations:

```
docker-compose run web bundle exec rake db:migrate
```

## Production env

Requirements:

1. Rails production environment requires https by default
1. `SECRET_KEY_BASE` containing your secret key. You can generate one with `bin/rails secret`.

