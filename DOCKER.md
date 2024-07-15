# Docker

The repository contains the `Dockerfile`. You can build and run the app with Docker.
App will be running on port `3000` by default. Database is not included.
So make sure to pass a `DATABASE_URL` to the container.

Docker compose:

```
docker-compose up --build
docker-compose run web bundle exec rake db:migrate
```

If you plan to use it for production then make sure to change `RAILS_ENV` and `SECRET_KEY_BASE_DUMMY` in `docker-compose.yml`.

