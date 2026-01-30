# Configuration Reference

Complete list of environment variables for MicroProject.app.

## Required Variables

| Variable | Description | How to Generate |
|----------|-------------|-----------------|
| `DATABASE_URL` | PostgreSQL connection string | `postgres://user:pass@host:5432/dbname` |
| `SECRET_KEY_BASE` | Rails secret for sessions/cookies | `openssl rand -hex 64` |

For self-hosted deployments, you may also need:
- `RAILS_MASTER_KEY` - Decrypts `config/credentials.yml.enc`

## Application Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_ENV` | Environment mode | `development` |
| `APP_DOMAIN` | Domain for the application | `localhost` |
| `APP_ALLOWED_EMAIL_DOMAIN` | Restrict signups to domain (e.g., `company.com`) | - |
| `APP_DISABLE_SIGNUP` | Disable new user registration | `false` |
| `DISABLE_EMAIL_LOGIN` | Only allow OAuth login | `false` |
| `WEB_CONCURRENCY` | Puma worker processes | `0` |

## AWS S3 (File Uploads)

Required for file attachments.

| Variable | Description |
|----------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_REGION` | S3 bucket region (e.g., `us-east-1`) |
| `AWS_S3_BUCKET` | S3 bucket name |

## OAuth Providers

### Google

| Variable | Description |
|----------|-------------|
| `GOOGLE_CLIENT_ID` | OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | OAuth client secret |
| `GOOGLE_REDIRECT_URI` | `https://YOUR_DOMAIN/users/auth/google_oauth2/callback` |

### Microsoft

| Variable | Description |
|----------|-------------|
| `MICROSOFT_CLIENT_ID` | Azure AD client ID |
| `MICROSOFT_CLIENT_SECRET` | Azure AD client secret |

Redirect URI: `https://YOUR_DOMAIN/users/auth/azure_activedirectory_v2/callback`

## Admin Tasks

### Make User Admin

```bash
# Local/Docker
bundle exec rake user:make_admin EMAIL=user@example.com

# Heroku
heroku run rake user:make_admin EMAIL=user@example.com
```

## Generating Secrets

```bash
# SECRET_KEY_BASE
openssl rand -hex 64

# Rails credentials (generates RAILS_MASTER_KEY)
SECRET_KEY_BASE_DUMMY=1 rails setup:credentials_and_db_encryption

# Quick env var generation
./bin/generate-env-vars
```
