# MicroProject MCP Server for Claude Code

Connect Claude Code to your MicroProject instance so it can read tasks, view details, create tasks, and toggle tasks done — from any project directory.

## 1. Generate an API Token

1. Log in to your MicroProject instance
2. Go to **Account** (`/users/account`)
3. Click **Generate Token**
4. Copy the token immediately (it's only shown in full once)

## 2. Configure Claude Code

The recommended way is with the CLI:

```bash
claude mcp add -s user microproject -- ruby /absolute/path/to/microprojectapp/mcp/server.rb
```

Then edit `~/.claude.json` to add the env vars to the `mcpServers.microproject.env` object:

```json
{
  "mcpServers": {
    "microproject": {
      "type": "stdio",
      "command": "ruby",
      "args": ["/absolute/path/to/microprojectapp/mcp/server.rb"],
      "env": {
        "MICROPROJECT_API_URL": "https://your-instance.example.com",
        "MICROPROJECT_API_TOKEN": "your-token-here"
      }
    }
  }
}
```

Replace:
- `/absolute/path/to/microprojectapp/mcp/server.rb` — full path to where you cloned this repo
- `MICROPROJECT_API_URL` — your MicroProject URL (no trailing slash)
- `MICROPROJECT_API_TOKEN` — the token you copied in step 1

Using `-s user` scope makes the tools available from **any** project directory, not just this repo.

## 3. Pointing at a Project

The MCP server resolves the project ID for each task-related call in this order:

1. Explicit `project_id` parameter passed to the tool (Claude can use `list_projects` to discover IDs)
2. `.microproject` file in the current working directory
3. `MICROPROJECT_PROJECT_ID` env var (optional default)

All three are optional individually — you just need at least one to apply when calling task tools.

**Option A — discover on demand (multi-project workflows).** Leave all three unset. Claude calls `list_projects` to find the project ID it needs, then passes `project_id` explicitly to task tools. Best when you regularly switch between several projects in the same session.

**Option B — per-repo pinning.** Drop a `.microproject` file in each codebase containing just the project ID:

```bash
echo "42" > .microproject
```

Add `.microproject` to your `.gitignore` since it contains a user-specific ID.

**Option C — single default.** Set `MICROPROJECT_PROJECT_ID` in the env block if you almost always work with the same project.

## 4. Restart Claude Code

After saving `settings.json`, restart Claude Code (or start a new session) for the MCP server to load.

## 5. Available Tools

Once configured, Claude Code can use these tools:

| Tool | What it does |
|------|-------------|
| `list_projects` | List every project the authenticated user has access to. Use to discover project IDs. |
| `list_tasks` | List tasks with status, stars, due dates. Filterable by `todo`, `done`, or `all`. |
| `get_task` | Get full task detail — description, assigned user, and comments. |
| `create_task` | Create a new task. Requires `name`, optional `description`, `due_date`, `star`. |
| `toggle_task_done` | Mark a task as done or reopen it. |

All task tools accept an optional `project_id` parameter to override the default.

## 6. Verify It Works

In any Claude Code session, ask:

> Show me my MicroProject tasks

Claude should call `list_tasks` and display your task list.

## Troubleshooting

**"MICROPROJECT_API_URL not set"** — The env vars in `settings.json` are missing or the MCP server didn't load. Check the path to `server.rb` is correct.

**401 Unauthorized** — Token is invalid or expired. Generate a new one from the Account page.

**403 Forbidden** — Your user doesn't have access to that project. Check the project ID.

**Connection refused** — The MicroProject instance isn't reachable at the configured URL.

## Requirements

- Ruby (any version with stdlib `json`, `net/http`, `uri` — no gems needed)
- A running MicroProject instance with the API enabled
