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

- Ruby 3.2.6
- PostgreSQL 14+
- Node.js (for asset compilation)

### macOS Setup

```bash
# Install Ruby via rbenv
brew install rbenv ruby-build
rbenv install 3.2.6
rbenv global 3.2.6

# Install PostgreSQL
brew install postgresql@14
brew services start postgresql@14
```

### Debian/Ubuntu Setup

#### Install Ruby with asdf

1. Install asdf following the [official guide](https://asdf-vm.com/guide/getting-started.html)

2. Add to your shell config:
   ```bash
   echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Install Ruby dependencies:
   ```bash
   sudo apt update
   sudo apt install -y build-essential libssl-dev zlib1g-dev libreadline-dev \
       libsqlite3-dev libcurl4-openssl-dev libffi-dev libyaml-dev
   ```

4. Install Ruby:
   ```bash
   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
   asdf install ruby 3.2.6
   asdf global ruby 3.2.6
   ruby -v
   ```

#### Install PostgreSQL

```bash
# Import repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install -y postgresql-14 postgresql-client-14 libpq-dev

# Start PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

#### Create Database User

```bash
sudo -u postgres psql
```

```sql
CREATE USER microproject WITH PASSWORD 'your_secure_password';
ALTER ROLE microproject CREATEDB;
\q
```

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

### Confirm User Email

If email confirmation isn't working:

```bash
bundle exec rake user:confirm_email EMAIL=user@example.com
```

### Running Tests

```bash
# Docker
docker-compose -f docker-compose.dev.yml exec web bundle exec rails test

# Native
rails test
```
