# Configuration Guide

This guide covers all configuration options needed to run the application in various environments.

## Admin Users

To make a user an admin, use the following commands:

    # When run locally
    bundle exec rake user:make_admin EMAIL=user@example.com

    # When deployed to Heroku
    heroku run rake user:make_admin EMAIL=user@example.com

## Confirm Users

In case email confirmation is not working, you can always confirm user manually with terminal:

    # When run locally
    bundle exec rake user:confirm_email EMAIL=user@example.com

    # When deployed to Heroku
    heroku run rake user:confirm_email EMAIL=user@example.com

## Rails Credentials

The application uses Rails encrypted credentials to securely store sensitive information like API keys and secret tokens.

To generate or edit the encrypted credentials file (`config/credentials.yml.enc`) and its master key (`config/master.key`):

    rails credentials:edit

Ensure you export the `RAILS_MASTER_KEY` environment variable in your production environment to allow Rails to decrypt the credentials:

    export RAILS_MASTER_KEY="your-unique-rails-master-key"

## Essential ENV Variables

For the app to run in production, the following environment variables are required:

- `DATABASE_URL`
- `RAILS_MASTER_KEY`

To generate some ENV variables automatically, run:

    ./bin/generate-env-vars

## Full List of ENV Variables

### Database

- `DATABASE_URL`

### Rails

- `RAILS_ENV` - can be `development`, `test`, `production`
- `RAILS_MASTER_KEY` - for `rails credentials:edit`
- `SECRET_KEY_BASE` - for securing signed cookies, sessions, and other encrypted data. You can generate one with `rails secret`

### App Variables

- `APP_DOMAIN` - set domain name to use for links and other resources, e.g., `APP_DOMAIN=myapp.heroku.com`
- `APP_ALLOWED_EMAIL_DOMAIN` - restrict users to a certain domain, e.g., `APP_ALLOWED_EMAIL_DOMAIN=company.com`
- `APP_SKIP_EMAIL_CONFIRMATION` - disable email confirmation for users after sign-up. OAuth users are confirmed by default.
- `APP_DISABLE_SIGNUP` - disable user sign-up if you don't want to allow new users.

### AWS S3

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `AWS_S3_BUCKET`

### Google OAuth

- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_REDIRECT_URI` - should be `https://YOUR_DOMAIN_NAME/users/auth/google_oauth2/callback`

### Microsoft OAuth

Redirect URI should be like `https://YOUR_DOMAIN_NAME/users/auth/azure_activedirectory_v2/callback`

- `MICROSOFT_CLIENT_ID`
- `MICROSOFT_CLIENT_SECRET`

### SMTP config

- `SMTP_SERVER`
- `SMTP_LOGIN`
- `SMTP_PASSWORD`

### Active Record (Database) Encryption

Some features like 2FA require an encryption key for the database. You can generate it with `./bin/rails db:encryption:init` and set the following variables:

- `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`
- `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY`
- `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`

