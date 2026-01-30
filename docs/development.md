# Development Guide

This guide covers setting up MicroProject.app for local development.

## Docker Development (Recommended)

The fastest way to get started:

```bash
git clone https://gitlab.com/dzaporozhets/microprojectapp.git
cd microprojectapp
docker-compose -f docker-compose.dev.yml up --build
```

- **URL**: http://localhost:3000
- **Database**: Auto-created and migrated
- **Hot reload**: Code changes reflected immediately

### Development Commands

```bash
# Rails console
docker-compose -f docker-compose.dev.yml exec web bundle exec rails console

# Reset database
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:reset

# Run tests
docker-compose -f docker-compose.dev.yml exec web bundle exec rails test
```

## Native Setup (Without Docker)

### Prerequisites

- Ruby 3.3.7
- PostgreSQL 14+

### Install the Application

```bash
git clone https://gitlab.com/dzaporozhets/microprojectapp.git
cd microprojectapp

bundle install
```

> **Troubleshooting**: If `bundle install` fails with `psych (5.1.2)` error, install libyaml: `sudo apt install -y libyaml-dev`

### Configure Database

Set your database credentials using one of these methods:

1. **Environment variable** (recommended):
   ```bash
   export DATABASE_URL=postgres://microproject:your_secure_password@localhost/microprojectapp_development
   ```

2. **Edit config/database.yml** directly with your credentials

### Setup and Run

```bash
# Setup database
rails db:setup

# Start the server
rails server
```

Access at http://localhost:3000

## Common Tasks

### Rails Console

```bash
# Docker
docker-compose -f docker-compose.dev.yml exec web bundle exec rails console

# Native
rails console
```

### Database Reset

```bash
# Docker
docker-compose -f docker-compose.dev.yml exec web bundle exec rails db:reset

# Native
rails db:reset
```

### Make User Admin

```bash
bundle exec rake user:make_admin EMAIL=user@example.com
```

### Running Tests

```bash
# Docker
docker-compose -f docker-compose.dev.yml exec web bundle exec rails test

# Native
rails test
```
