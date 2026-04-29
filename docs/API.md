# API Reference

MicroProject provides a REST API for reading and managing tasks programmatically.

## Authentication

All requests require a Bearer token in the `Authorization` header:

```
Authorization: Bearer YOUR_API_TOKEN
```

Generate a token from your **Account** page (`/users/account`). Tokens are scoped to your user — you can access any project you own or are invited to.

## Rate Limiting

Requests to `/api/*` are throttled to `60` requests per minute per bearer token. When the limit is exceeded, the app returns:

```json
{ "error": "Throttle limit reached. Try again later." }
```

with HTTP `429 Too Many Requests`.

## Endpoints

### List Tasks

```
GET /api/v1/projects/:project_id/tasks
```

**Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `project_id` | integer | **Required.** Project ID (path) |
| `status` | string | Filter: `todo` or `done`. Any other value returns all tasks. |
| `due` | string | Filter by due date: `today`, `overdue` (past due and not done), `this_week`, `none` (no due date), or an explicit `YYYY-MM-DD`. Returns `400` for an invalid value. |
| `assigned` | string | Filter by assignee: `me` (the token owner), `unassigned`, or a numeric user ID. Returns `400` for an invalid value. |

Filters are independent — `status`, `due`, and `assigned` can be combined.

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
      "assigned_user_id": 7,
      "assigned_user_email": "alice@example.com",
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

### Create Task

```
POST /api/v1/projects/:project_id/tasks
Content-Type: application/json
```

**Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `name` | string | **Required.** Max length `512`. |
| `description` | string | Optional task description |
| `due_date` | date | Optional due date |
| `star` | boolean | Optional starred state |
| `assigned_user_id` | integer | Optional assignee. Must belong to the project team or it is ignored. |

Successful response: HTTP `201 Created`

### Toggle Task Done

```
PATCH /api/v1/projects/:project_id/tasks/:id/toggle_done
```

```json
{
  "task": {
    "id": 42,
    "name": "Update landing page",
    "done": true,
    "star": true,
    "due_date": "2026-03-01",
    "done_at": "2026-02-25T12:00:00.000Z",
    "assigned_user_id": 7,
    "assigned_user_email": "alice@example.com",
    "created_at": "2026-02-20T10:00:00.000Z",
    "updated_at": "2026-02-25T12:00:00.000Z",
    "comment_count": 3
  }
}
```

### Create Comment

```
POST /api/v1/projects/:project_id/tasks/:task_id/comments
Content-Type: application/json
```

**Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `body` | string | **Required.** Comment body |

**Response:** HTTP `201 Created`

```json
{
  "comment": {
    "id": 7,
    "body": "Draft is ready for review.",
    "user_email": "bob@example.com",
    "created_at": "2026-02-22T09:00:00.000Z"
  }
}
```

## Errors

Errors return JSON with either an `error` key or an `errors` key for validation failures:

```json
{ "error": "Unauthorized" }
```

Validation failures:

```json
{ "errors": ["Name can't be blank"] }
```

| Status | Meaning |
|--------|---------|
| `401` | Missing or invalid token |
| `403` | Token valid but no access to this project |
| `404` | Project or task not found |
| `422` | Validation error or failed update |
| `429` | Rate limit exceeded |

## Example: curl

```bash
curl -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks?status=todo

curl -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks/42

# Create a task
curl -X POST \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"task":{"name":"Write API docs","star":true}}' \
  https://your-instance.example.com/api/v1/projects/1/tasks

# Mark task done (or reopen)
curl -X PATCH \
  -H "Authorization: Bearer TOKEN" \
  https://your-instance.example.com/api/v1/projects/1/tasks/42/toggle_done

# Add a comment to a task
curl -X POST \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"comment":{"body":"Looks good to me."}}' \
  https://your-instance.example.com/api/v1/projects/1/tasks/42/comments
```
