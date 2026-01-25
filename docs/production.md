# Production Deployment

## Required Configuration

| Variable | Description |
|----------|-------------|
| `SECRET_KEY_BASE` | `openssl rand -hex 64` |
| `DATABASE_URL` | Provided by platform |

See [config.md](CONFIG.md) for email, file uploads, and OAuth.

## Cloud Platforms

### DigitalOcean App Platform

1. Connect repo, set Dockerfile path
2. Add managed PostgreSQL
3. Set `DATABASE_URL` → `${db.DATABASE_URL}`, `SECRET_KEY_BASE`

### Render

1. Connect repo (auto-detects Dockerfile)
2. Add PostgreSQL, set `DATABASE_URL` and `SECRET_KEY_BASE`

### Railway

1. Connect repo, add PostgreSQL plugin
2. Set `SECRET_KEY_BASE` (DATABASE_URL auto-configured)

### Fly.io

```bash
fly launch && fly postgres create && fly postgres attach
fly secrets set SECRET_KEY_BASE=$(openssl rand -hex 64)
fly deploy
```

### Heroku

```bash
heroku create
heroku addons:create heroku-postgresql:essential-0
git push heroku main
heroku run rails db:migrate && heroku run rails db:seed
```

## Self-Hosted

See [self-hosted.md](self-hosted.md) for VPS deployment with Nginx/Puma.

## Updating

Push to connected repo (auto-deploys), then run migrations if needed.
