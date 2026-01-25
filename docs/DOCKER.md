# Docker

You can run the app with Docker for quick testing and development. The setup includes automated database creation, migrations, and SSL certificate generation.

## Quick Start

### Development Environment

The development setup includes Rails and PostgreSQL with hot reloading:

```bash
docker-compose -f docker-compose.dev.yml up --build
```

- **Access**: http://localhost:3000
- **Database**: Automatically created and migrated
- **Hot reload**: Code changes are reflected immediately
- **Email**: Disabled for development

### Production Environment

The production setup includes Rails, PostgreSQL, and Nginx with HTTPS:

```bash
SECRET_KEY_BASE=$(openssl rand -hex 64) docker-compose -f docker-compose.prod.yml up --build
```

- **Access**: https://localhost (nginx proxy)
- **Database**: Automatically created and migrated
- **SSL**: Self-signed certificates auto-generated
- **Email**: Uses sendmail with async delivery

## Docker Files

- **Dockerfile**: Minimal production image for cloud platforms (DO, Render, etc.)
- **Dockerfile.full**: Full production environment with nginx/sendmail for docker-compose
- **Dockerfile.dev**: Development environment with hot reload
- **docker-compose.dev.yml**: Development stack (Rails + PostgreSQL)
- **docker-compose.prod.yml**: Production stack (Rails + PostgreSQL + Nginx)

## What's Automated

The Docker setup handles:
- Database creation and migrations
- SSL certificate generation
- Asset compilation (production)
- Async email delivery
- Environment configuration

## Manual Commands

If you need to run commands manually:

```bash
# Development
docker-compose -f docker-compose.dev.yml exec web bundle exec rails console
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:reset

# Production
SECRET_KEY_BASE=$(openssl rand -hex 64) docker-compose -f docker-compose.prod.yml exec web bundle exec rails console
```

## Cloud Deployment (DigitalOcean, Render, etc.)

The minimal `Dockerfile` is optimized for cloud platforms that provide managed databases and TLS termination.

### Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `SECRET_KEY_BASE` | Rails secret key | `openssl rand -hex 64` |
| `DATABASE_URL` | PostgreSQL connection string | `postgres://user:pass@host:5432/db` |
| `RAILS_ENV` | Environment (usually auto-set) | `production` |

### Optional Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_DOMAIN` | Your app's domain for emails | - |
| `SMTP_SERVER` | SMTP host for email delivery | - |
| `SMTP_LOGIN` | SMTP username | - |
| `SMTP_PASSWORD` | SMTP password | - |
| `DISABLE_EMAIL_DELIVERY` | Disable all emails | `false` |

### DigitalOcean App Platform

1. Connect your GitHub repo
2. Edit App Spec to use Dockerfile:
   ```yaml
   services:
   - dockerfile_path: Dockerfile
     http_port: 3000
   ```
3. Add a managed PostgreSQL database
4. Bind `DATABASE_URL` to `${db.DATABASE_URL}`
5. Set `SECRET_KEY_BASE` in environment variables

## Notes

- `docker-compose` setups are for **testing and local development**
- For production, use cloud platforms (DO, Render, Heroku) with the minimal `Dockerfile`
- Configure SMTP for email delivery in production (sendmail not included in minimal image)
- Cloud platforms handle TLS termination - no certificate setup needed

