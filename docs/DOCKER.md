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

- **Dockerfile**: Production environment
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

## Notes

- Docker is for **testing and quick starts only**
- For production deployments, use Heroku or proper VPS setup
- Email functionality is limited in Docker environment
- SSL certificates are self-signed (browser security warnings expected)

