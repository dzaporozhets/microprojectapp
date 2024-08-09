# Docker

You can build and run the app with Docker. App will be running on port `3000` by default.

## Dockerfile 

The repository contains the `Dockerfile`. Database is not included there. 
So make sure to pass a `DATABASE_URL` to the container.

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

