# README

* [Website](https://about.microproject.app/)
* [MIT License](LICENSE)

## Running

### Using cloud platform as a service (easy)

If you want an easy and fast way to run the application, we recommend using [Heroku](https://www.heroku.com/).
We made a simple guide on how to [deploy this app to HEROKU](HEROKU.md).

### Using your own server or VPS

See [installation instructions](INSTALL.md) for running application on your laptop or any linux server.

### Run as container

See [Docker instructions](DOCKER.md) for that.

## Extra commands

#### Admin users

How to make user an admin:

```
# When run locally
bundle exec rake user:make_admin EMAIL=user@example.com

# When deployed to heroku
heroku run rake user:make_admin EMAIL=user@example.com
```

## ENV variables

Database:

* `DATABASE_URL`

Rails variables:

* `RAILS_ENV` - can be `development`, `test`, `production`

App variables:

* `APP_DOMAIN` - set domain name to use for links and other resources. For example `APP_DOMAIN=myapp.heroku.com`
* `APP_ALLOWED_EMAIL_DOMAIN` - restrict users to certain domain. For example `APP_ALLOWED_EMAIL_DOMAIN=company.com`
* `APP_EMAIL_CONFIRMATION` - require email confirmation for users after sign up.

AWS S3:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`
* `AWS_S3_BUCKET`

Google oauth:

* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`
* `GOOGLE_REDIRECT_URI`

Mailgun:

* `MAILGUN_DOMAIN`
* `MAILGUN_SMTP_SERVER`
* `MAILGUN_SMTP_LOGIN`
* `MAILGUN_SMTP_PASSWORD`

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Developer Certificate of Origin

By contributing to this project, you agree to the [Developer Certificate of Origin (DCO)](DCO). We encourage all contributors to sign off their commits using `Signed-off-by: Your Name <your.email@example.com>`. You can do this by adding `-s` to your git commit command.
