# README

* [Website](https://about.microproject.app/)
* [MIT License](LICENSE)
* [Running](#running)
* [Admin users](#admin-users)
* [Configuration](#env-variables)
* [Contact](#contact)

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

## Rails credentials

1. Generate `config/credentials.yml.encrypted` and `config/master.key`

```
rails credentials:edit
```

2. Copy `config/master.key` into `RAILS_MASTER_KEY` variable.

```
export RAILS_MASTER_KEY="your-unique-rails-master-key"
```

3. Make sure both `config/credentials.yml.encrypted` and `RAILS_MASTER_KEY` are present for deployed app.


## ENV variables

The bare minimum for Rails app to work in production: `DATABASE_URL`, `RAILS_MASTER_KEY`.

You can run `./bin/generate-env-vars` to generate some of the ENV variables for you.

Below are all available ENV variables used by the app

Database:

* `DATABASE_URL`

Rails variables:

* `RAILS_ENV` - can be `development`, `test`, `production`
* `RAILS_MASTER_KEY` - for `rails credentials:edit`
* `SECRET_KEY_BASE` - for securing signed cookies, sessions, and other encrypted data. You can generate one with `rails secret`

App variables:

* `APP_DOMAIN` - set domain name to use for links and other resources. For example `APP_DOMAIN=myapp.heroku.com`
* `APP_ALLOWED_EMAIL_DOMAIN` - restrict users to certain domain. For example `APP_ALLOWED_EMAIL_DOMAIN=company.com`
* `APP_SKIP_EMAIL_CONFIRMATION` - do not require email confirmation for users after sign up. Can be useful if you don't want to setup email. OAuth users are confirmed by default.
* `APP_DISABLE_SIGNUP` - disables sign-up. Use this if you don't want to allow any new users.

AWS S3:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`
* `AWS_S3_BUCKET`

Google oauth:

* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`
* `GOOGLE_REDIRECT_URI` - Should be `https://YOUR_DOMAIN_NAME/users/auth/google_oauth2/callback`

Microsoft oauth:

Redirect URI should be like `https://YOUR_DOMAIN_NAME/users/auth/azure_activedirectory_v2/callback`

* `MICROSOFT_CLIENT_ID`
* `MICROSOFT_CLIENT_SECRET`

Mailgun:

* `MAILGUN_DOMAIN`
* `MAILGUN_SMTP_SERVER`
* `MAILGUN_SMTP_LOGIN`
* `MAILGUN_SMTP_PASSWORD`

Active Record (database) encryption:

Some features like 2FA requires ecryption key for the database. You can either generate it with `./bin/rails db:encryption:init` and put into variables below or generate it yourself with random hex 32.

* `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`
* `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY`
* `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`


## Contact

If you have questions, feedback, or suggestions, feel free to reach out:
* **Create an Issue**: Open an issue on this project to report bugs, request features, or ask questions.
* **Twitter** Mention me on [Twitter](https://x.com/dzaporozhets) at `@dzaporozhets`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Developer Certificate of Origin

By contributing to this project, you agree to the [Developer Certificate of Origin (DCO)](DCO). We encourage all contributors to sign off their commits using `Signed-off-by: Your Name <your.email@example.com>`. You can do this by adding `-s` to your git commit command.
