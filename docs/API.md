# API Reference

MicroProject provides a REST API for reading and managing tasks programmatically.

## Authentication

All requests require a Bearer token in the `Authorization` header:

```
Authorization: Bearer YOUR_API_TOKEN
```

Generate a token from your **Account** page (`/users/account`). Tokens are scoped to your user — you can access any project you own or are invited to.

To revoke a token, click **Regenerate Token** (invalidates the old one).

## Rate Limiting

API requests are throttled to **60 requests per minute** per token. Exceeding this returns `429 Too Many Requests`.

## Endpoints

### List Tasks

```
GET /api/v1/projects/:project_id/tasks
```

**Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `project_id` | integer | **Required.** Project ID (path) |
| `status` | string | Filter: `todo`, `done`, or `all` (default: `all`) |

**Response:**

```json
{
  "project": {
    "id": 1,
    "name": "My Project"
  },
  "tasks": [
    {
      "id": 42,
      "name": "Update landing page",
      "done": false,
      "star": true,
      "due_date": "2026-03-01",
      "done_at": null,
      "created_at": "2026-02-20T10:00:00.000Z",
      "updated_at": "2026-02-24T15:30:00.000Z",
      "comment_count": 3
    }
  ]
}
```

### Get Task

```
GET /api/v1/projects/:project_id/tasks/:id
```

Returns full task detail including description and comments.

**Response:**

```json
{
  "task": {
    "id": 42,
    "name": "Update landing page",
    "description": "Redesign the hero section and update copy.",
    "done": false,
    "star": true,
    "due_date": "2026-03-01",
    "done_at": null,
    "assigned_user_email": "alice@example.com",
    "created_at": "2026-02-20T10:00:00.000Z",
    "updated_at": "2026-02-24T15:30:00.000Z",
    "comments": [
      {
        "id": 1,
        "body": "Draft is ready for review.",
        "user_email": "bob@example.com",
        "created_at": "2026-02-22T09:00:00.000Z"
      }
    ]
  }
}
```

### Toggle Task Done

```
PATCH /api/v1/projects/:project_id/tasks/:id/toggle_done
```

Toggles the task between done and not done. Creates an activity log entry.

**Response:**

```json
{
  "task": {
    "id": 42,
    "name": "Update landing page",
    "done": true,
    "star": true,
    "due_date": "2026-03-01",
    "done_at": "2026-02-25T12:00:00.000Z",
    "created_at": "2026-02-20T10:00:00.000Z",
    "updated_at": "2026-02-25T12:00:00.000Z",
    "comment_count": 3
  }
}
```

## Errors

All errors return JSON with an `error` key:

```json
{ "error": "Unauthorized" }
```

| Status | Meaning |
|--------|---------|
| `401` | Missing or invalid token |
| `403` | Token valid but no access to this project |
| `404` | Project or task not found |
| `422` | Update failed (validation error) |
| `429` | Rate limit exceeded |

## Example: curl

```bash
# List todo tasks
curl -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks?status=todo

# Get task detail
curl -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks/42

# Mark task done (or reopen)
curl -X PATCH -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks/42/toggle_done
```
