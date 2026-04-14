## Code Analysis — MANDATORY

**You MUST use Kai MCP tools** (kai_diff, kai_grep, kai_context, kai_callers, kai_callees, kai_impact, etc.) for ALL code exploration, searching, diffing, and analysis. Do NOT use raw Grep, Read, git-diff, or the Explore agent for these tasks. Only fall back to raw tools when the Kai MCP server is unavailable or the specific query is not covered by any Kai tool.

**Do NOT delegate code exploration to subagents (e.g., Explore agents).** Subagents cannot use Kai MCP tools. Instead, call the Kai MCP tools directly from the main conversation.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MicroProject.app is a lightweight Rails-based project management tool for individuals and small teams. It uses Rails 7.2.3, Ruby 3.3.7, PostgreSQL, Stimulus.js, Turbo Rails, and Tailwind CSS.

## Code Analysis

If `.kai/` directory exists and Kai MCP is available, prefer Kai for:
- `kai_impact` — change impact analysis with hop distance
- `kai_context` — file/symbol dependency summary in one call
- `kai_symbols` — list all symbols in a file (richer than regex: includes associations, callbacks, scopes)
- `kai_dependencies`, `kai_dependents` — file-level dependency graph

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

### Validate Changes
```bash
bin/all_tests                 # Run all checks (rubocop, brakeman, rspec, coverage >= 98%)
```

Always run `bin/all_tests` after completing a task to verify nothing is broken.

### Releasing
See `release.txt` for the full release procedure. Run `git fetch --tags` first to ensure you have the latest tags before determining the current version. Key steps: bump version in `config/initializers/version.rb` and `CHANGELOG.txt`, run `bin/all_tests`, commit, and tag.

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
- **Reusable CSS components** defined in `app/assets/stylesheets/application.tailwind.css` — see `docs/dev/frontend.md` for the full reference with ERB examples. Prefer these classes over inline Tailwind for common UI patterns (buttons, forms, cards, lists, etc.)

### Key Domain Limits
- Max 3,999 tasks per project
- Max 100 files per project
- Max 999 activity log entries per project (oldest deleted when exceeded)
- Max 999 projects per user

### File Uploads
Active Storage handles file attachments (note attachments, comment attachments, user avatars) with AWS S3 or local storage. Disabled by default — requires S3 configuration or `ENABLE_LOCAL_FILE_STORAGE`.

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
- `GET /api/v1/projects` — List projects the authenticated user has access to
- `GET /api/v1/projects/:project_id/tasks?status=todo|done|all` — List tasks
- `GET /api/v1/projects/:project_id/tasks/:id` — Task detail with comments
- `POST /api/v1/projects/:project_id/tasks` — Create task (params: `name`, `description`, `due_date`, `star`, `assigned_user_id`)
- `PATCH /api/v1/projects/:project_id/tasks/:id/toggle_done` — Toggle done
- `POST /api/v1/projects/:project_id/tasks/:task_id/comments` — Add a comment (params: `body`)

### Rate Limit
60 requests/minute per token.

## MCP Server

A standalone MCP server at `mcp/server.rb` exposes MicroProject tasks to Claude Code.

### Setup
```bash
claude mcp add -s user microproject -- ruby /absolute/path/to/microprojectapp/mcp/server.rb
```
Then add env vars to `~/.claude.json` under `mcpServers.microproject.env`:
- `MICROPROJECT_API_URL` — your instance URL
- `MICROPROJECT_API_TOKEN` — token from Account page
- `MICROPROJECT_PROJECT_ID` — optional default project ID

For multi-project workflows, leave `MICROPROJECT_PROJECT_ID` unset and let Claude call `list_projects` to discover IDs, or create a `.microproject` file per repo with just the project ID.

See `mcp/README.md` for full setup instructions.

### Tools
- `list_projects` — List projects accessible to the token's user
- `list_tasks` — List tasks with checkbox notation
- `get_task` — Full detail with description + comments
- `create_task` — Create a new task
- `create_comment` — Add a comment to a task
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
