# README

## Running

Create the database:

    rails db:setup

To start a web server for the application, run:

    rails s

Now visit http://localhost:3000/ to see the app running.

### Run as container

The repository contains the `Dockerfile`. You can build and run the app with Docker.
App will be running on port `3000` by default. Database is not included.
So make sure to pass a `DATABASE_URL` to the container.

Docker compose:

```
docker-compose up --build
docker-compose run web bundle exec rake db:migrate
```

If you plan to use it for production then make sure to change `RAILS_ENV` and `SECRET_KEY_BASE_DUMMY` in `docker-compose.yml`.

### Running on Heroku

Clone the repository and cd into it. Then execute next commands:

```
# Create a heroku project
heroku create

# Add Postgresql database
heroku addons:create heroku-postgresql:essential-0

# Deploy application
git push heroku main

# Prepare the database.
# If command below fails, maybe postgresql provision is not ready yet.
# Give it a try in a minute or two.
heroku run rails db:migrate

# Fill database with necessary data
heroku run rails db:seed

# Open the app in web browser
heroku open
```

The last command should open the application in your browser.

Extra:

File uploads via Amazon S3.

Create the S3 bucket and set following credentilas with heroku:

```
heroku config:set AWS_ACCESS_KEY_ID=
heroku config:set AWS_SECRET_ACCESS_KEY=
heroku config:set AWS_REGION=
heroku config:set AWS_S3_BUCKET=
```

### Extra commands

How to make user an admin

```
# When run locally
bundle exec rake user:make_admin EMAIL=user@example.com

# When deployed to heroku
heroku run rake user:make_admin EMAIL=user@example.com
```
