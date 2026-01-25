# Self-Hosted Deployment Guide

This guide covers deploying MicroProject.app on your own VPS or server.

## Overview

Self-hosting gives you full control over your deployment but requires more setup than cloud platforms.

| Approach | Best For |
|----------|----------|
| **Docker** | Quick setup, easier updates |
| **Native** | Maximum control, lower resource usage |

**Prerequisites**: A VPS with Ubuntu/Debian, a domain name, and SSH access.

## Docker Deployment

### Build and Run

```bash
# Clone repository
git clone https://gitlab.com/dzaporozhets/microprojectapp.git
cd microprojectapp

# Build production image
docker build -t microproject .

# Run with your database
docker run -d -p 3000:3000 \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  -e DATABASE_URL=postgres://user:pass@host:5432/db \
  --name microproject \
  microproject
```

Then set up a reverse proxy (Nginx, Caddy, or Traefik) to handle SSL and forward traffic to port 3000.

## Native Deployment (Nginx + Puma)

### 1. Install Ruby and PostgreSQL

Follow the Debian/Ubuntu setup in the [Development Guide](development.md#debianubuntu-setup), then return here.

### 2. Clone and Install Dependencies

```bash
git clone https://gitlab.com/dzaporozhets/microprojectapp.git
cd microprojectapp

bundle config set --local without 'development test'
bundle install
```

> If `bundle install` fails with `psych` error: `sudo apt install -y libyaml-dev`

### 3. Configure Database

Choose one method:

**Option A** - Environment variable:
```bash
export DATABASE_URL=postgres://microproject:password@localhost/microprojectapp_production
```

**Option B** - Edit `config/database.yml` directly

### 4. Configure Secrets

Generate all required secrets:

```bash
SECRET_KEY_BASE_DUMMY=1 rails setup:credentials_and_db_encryption
```

Copy the `RAILS_MASTER_KEY` from the output and export it:

```bash
export RAILS_MASTER_KEY="your-key-from-output"
```

**Important**: Back up both `config/credentials.yml.enc` and `RAILS_MASTER_KEY`.

### 5. Setup Database and Assets

```bash
RAILS_ENV=production rails db:setup
RAILS_ENV=production rails assets:precompile
```

### 6. Test the Application

```bash
RAILS_ENV=production rails server -b 0.0.0.0
```

If it starts without errors, stop it (Ctrl+C) and proceed.

### 7. Install and Configure Nginx

```bash
sudo apt install nginx
```

Create `/etc/nginx/sites-available/microprojectapp`:

```nginx
server {
    listen 80;
    server_name your_domain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name your_domain.com;

    ssl_certificate /etc/letsencrypt/live/your_domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain.com/privkey.pem;

    root /path/to/microprojectapp/public;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Replace `your_domain.com` with your domain and `/path/to/microprojectapp` with the actual path.

Enable the configuration:

```bash
sudo ln -s /etc/nginx/sites-available/microprojectapp /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Optional
sudo nginx -t
sudo systemctl restart nginx
```

### 8. SSL with Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your_domain.com
```

### 9. Create Puma Systemd Service

Create `/etc/systemd/system/microprojectapp.service`:

```ini
[Unit]
Description=MicroProject.app Puma Server
After=network.target

[Service]
Type=simple
User=your_user
WorkingDirectory=/path/to/microprojectapp
Environment=RAILS_ENV=production
Environment=APP_DOMAIN=your_domain.com
Environment=RAILS_MASTER_KEY=your_master_key
ExecStart=/home/your_user/.asdf/shims/bundle exec puma -C config/puma.rb
Restart=always

[Install]
WantedBy=multi-user.target
```

Replace placeholders with your values. Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable microprojectapp
sudo systemctl start microprojectapp
```

Check status:

```bash
sudo systemctl status microprojectapp
```

## Updating Self-Hosted Installation

### Docker

```bash
cd microprojectapp
git pull
docker build -t microproject .
docker stop microproject
docker rm microproject
docker run -d -p 3000:3000 \
  -e SECRET_KEY_BASE=your_secret \
  -e DATABASE_URL=your_database_url \
  --name microproject \
  microproject
```

### Native

```bash
cd microprojectapp
git pull
bundle install
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails assets:precompile
sudo systemctl restart microprojectapp
```

## Configuration

See [Configuration Reference](config.md) for environment variables including:
- Email (SMTP)
- File uploads (AWS S3)
- OAuth providers (Google, Microsoft)
- Database encryption (for 2FA)
