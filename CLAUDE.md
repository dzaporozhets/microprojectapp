# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MicroProject.app is a lightweight Rails-based project management tool for individuals and small teams. It uses Rails 7.2.3, Ruby 3.3.7, PostgreSQL, Stimulus.js, Turbo Rails, and Tailwind CSS.

## Common Commands

### Development Setup (Docker - Recommended)
```bash
docker-compose -f docker-compose.dev.yml up --build
# Access at http://localhost:3000
```

### Development Setup (Native)
```bash
bundle install
export DATABASE_URL=postgres://user:pass@localhost/project2_development
rails db:setup
rails server
```

### Testing
```bash
# Run full test suite
bundle exec rspec

# Run single test file
bundle exec rspec spec/models/user_spec.rb

# Run single test by line number
bundle exec rspec spec/models/user_spec.rb:42
```

### Code Quality
```bash
bundle exec rubocop           # Linting
bundle exec brakeman          # Security scanning
```

### Database Operations
```bash
rails db:migrate
rails db:rollback
rails db:reset
rails db:seed
rails console
```

### Admin Tasks
```bash
bundle exec rake user:make_admin EMAIL=user@example.com
```

## Architecture

### Backend Structure
- **Controllers** are namespaced: `admin/` for admin panel, `project/` for project-related actions, `users/` for user settings and OAuth callbacks
- **Services** in `app/services/` contain business logic for complex operations (ProjectExport, ProjectImport, validation)
- **Models** use ActiveRecord with associations; Paper Trail tracks task name/description changes (max 5 versions per task)
- **Authentication**: Devise with optional Google OAuth2 and Microsoft Entra ID support

### Frontend Structure
- **Stimulus controllers** in `app/javascript/controllers/` handle client-side interactivity
- **Turbo Rails** provides SPA-like navigation without full-page reloads
- **Tailwind CSS** for styling; themes available: Gray, Indigo, Orange, Pink, Violet

### Key Domain Limits
- Max 3,999 tasks per project
- Max 100 files per project
- Max 999 activity log entries per project (oldest deleted when exceeded)
- Max 999 projects per user

### File Uploads
CarrierWave handles uploads to AWS S3 (production) or local storage (development). Uploaders are in `app/uploaders/`.

## Testing Conventions

- RSpec with FactoryBot factories in `spec/factories/`
- System tests use Capybara + Selenium (Chrome headless)
- DatabaseCleaner with transaction strategy
- SimpleCov for coverage reports

## Code Style: Newlines

Follow these Ruby newline conventions:

- **Group related logic** - Separate code with newlines only to group together related logic
- **Add newlines around blocks** - Insert a blank line before conditionals/control structures and after completed blocks
- **No extra spacing for nested blocks** - When blocks are nested directly inside another block, no extra newline is needed at the start or end

```ruby
# Good - newline separates setup from conditional
user = User.find(params[:id])

if user.admin?
  # ...
end

# Good - no extra newlines inside nested blocks
if condition
  if nested_condition
    # ...
  end
end
```

## API

Token-authenticated REST API scoped to projects the user has access to.

### Authentication
Include `Authorization: Bearer <token>` header. Generate tokens at `/users/account`.

### Endpoints
- `GET /api/v1/projects/:project_id/tasks?status=todo|done|all` — List tasks
- `GET /api/v1/projects/:project_id/tasks/:id` — Task detail with comments
- `PATCH /api/v1/projects/:project_id/tasks/:id/toggle_done` — Toggle done

### Rate Limit
60 requests/minute per token.

## MCP Server

A standalone MCP server at `mcp/server.rb` exposes MicroProject tasks to Claude Code.

### Setup
Add to `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "microproject": {
      "command": "ruby",
      "args": ["/absolute/path/to/microprojectapp/mcp/server.rb"],
      "env": {
        "MICROPROJECT_API_URL": "https://your-vps.example.com",
        "MICROPROJECT_API_TOKEN": "your-token-from-account-page",
        "MICROPROJECT_PROJECT_ID": "1"
      }
    }
  }
}
```

### Tools
- `list_tasks` — List tasks with checkbox notation
- `get_task` — Full detail with description + comments
- `toggle_task_done` — Toggle done/undone

## Environment Variables

See `/docs/CONFIG.md` for full reference. Key variables:
- `DATABASE_URL` - PostgreSQL connection
- `SECRET_KEY_BASE` - Rails encryption key
- `AWS_*` - S3 configuration for file uploads
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` - Google OAuth
- `MICROSOFT_CLIENT_ID`, `MICROSOFT_CLIENT_SECRET`, `MICROSOFT_TENANT_ID` - Microsoft OAuth
- `DISABLE_EMAIL_LOGIN` - Disable email/password auth when using OAuth only
- `ENABLE_LOCAL_FILE_STORAGE` - Enable file uploads without S3 configured
