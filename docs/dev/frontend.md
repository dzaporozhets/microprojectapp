# Frontend Component Reference

Reusable CSS component classes defined in `app/assets/stylesheets/application.tailwind.css`. Use these instead of writing inline Tailwind for common UI patterns.

## Quick Reference

| Class | Purpose |
|---|---|
| `.body-color` | Page background + text color (light/dark) |
| `.bg-base` | White/dark surface background |
| `.main-container` | Centered max-width page wrapper |
| `.content` | Standard margin around page content |
| `.border-base` | Themed border color |
| `.text-default` | Default body text color |
| `.nav-container` | Top navigation bar |
| `.nav-title` | Nav row for project title |
| `.nav-controls` | Nav row for tabs/actions |
| `.nav-title-link` | Bold project name in nav |
| `.btn` | Base button reset (not used directly) |
| `.btn-sm` | Small button variant |
| `.icon-btn` | Icon-only button |
| `.btn-base` | Default gray button |
| `.btn-base-sm` | Small gray button |
| `.btn-primary` | Violet primary action button |
| `.btn-primary-sm` | Small primary button |
| `.btn-danger` | Red destructive button |
| `.btn-remove` | Gray button that turns red on hover |
| `.form-label` | Form field label |
| `.form-section` | Divided form group |
| `.error-box` | Validation error container |
| `.base-input` | Text input / textarea styling |
| `.checkbox` | Styled checkbox |
| `.radio` | Styled radio button |
| `.file-select` | File input styling |
| `.tab-container` | Tab group wrapper |
| `.tab` | Inactive tab |
| `.tab-active` | Active tab |
| `.flash-notice` | Success/info flash message |
| `.flash-alert` | Error/warning flash message |
| `.resource-container` | Card wrapper with shadow + rounded corners |
| `.resource-header` | Card header with border |
| `.resource-body` | Card body with padding |
| `.resource-title` | Bold card title |
| `.resource-subtitle` | Semibold secondary title |
| `.resource-description` | Muted description text |
| `.resource-list` | Divided list inside a card |
| `.resource-empty-state` | Empty state container |
| `.resource-empty-icon` | Empty state SVG icon |
| `.resource-empty-title` | Empty state heading |
| `.resource-empty-description` | Empty state body text |
| `.resource-empty-action` | Empty state CTA wrapper |
| `.data-row` | Key-value row (flex, spaced) |
| `.data-label` | Label in a data row |
| `.list-row` | Horizontal list item layout |
| `.list-item-content` | Flexible content area in a list row |
| `.list-item-actions` | Right-aligned action buttons in a list row |
| `.task-done` | Strikethrough styling for completed tasks |
| `.task-todo` | Bold styling for open tasks |
| `.task-name` | Task name text (clamped to 2 lines) |
| `.status-dot-overdue` | Small red dot for overdue indicator |
| `.text-muted` | Gray secondary text |
| `.text-primary` | Default-color medium-weight text |
| `.text-secondary` | Small muted text |
| `.list-text-primary` | Small medium-weight list text |
| `.list-text-secondary` | Extra-small muted list text |
| `.comment-body` | Comment text with word-break |
| `.avatar-bg` | Circular avatar background |
| `.link-primary` | Violet link with hover state |
| `.checkbox-round` | Round checkbox (used for task toggles) |

---

## Base & Theme

These classes set up the page-level foundations. Applied in layouts, not in feature views.

```erb
<%# app/views/layouts/application.html.erb %>
<body class="body-color">
  <main class="main-container">
    <div class="content w-full">
      <%= yield %>
    </div>
  </main>
</body>
```

`bg-base` is used on surfaces that need the white/dark-gray card background:

```erb
<div class="bg-base">
  <%# card content %>
</div>
```

`border-base` and `text-default` are consumed by other component classes (e.g. `.nav-container` applies `border-base` internally). Use them when you need a themed border or text color on a custom element.

---

## Buttons

All buttons extend the `.btn` base class which provides padding, rounded corners, focus ring, and an active press animation.

### Variants

**Default (gray) button** — `.btn-base`
```erb
<%= link_to "Add Link", new_project_link_path(@project), class: "btn-base" %>
```

**Small gray button** — `.btn-base-sm`
```erb
<%= link_to "Invite People", invite_project_users_path(@project), class: "btn-base-sm" %>
```

**Primary (violet) button** — `.btn-primary`
```erb
<%= f.submit "Log in", class: "btn-primary w-full" %>
<%= form.submit "Save changes", class: "btn-primary" %>
```

**Small primary button** — `.btn-primary-sm`
```erb
<%= f.submit "Save", class: "btn-primary-sm" %>
```

**Danger (red) button** — `.btn-danger`
```erb
<%= button_to "Delete this account", admin_user_path(@user),
    method: :delete,
    data: { turbo_confirm: "Delete account with all the data? Are you sure?" },
    class: "btn-danger" %>
```

**Remove (gray-to-red hover) button** — `.btn-remove`
```erb
<%= button_to "Delete this task", [task.project, task],
    method: :delete,
    data: { turbo_confirm: "Delete the task? Are you sure?" },
    class: "btn-remove" %>
```

**Small button** — `.btn-sm`
```erb
<%= link_to edit_project_task_path(@task.project, @task),
    data: { turbo: true }, class: "btn-sm", title: "Edit" do %>
  <%# icon SVG %>
<% end %>
```

**Icon button** — `.icon-btn`
```erb
<%= link_to link.url, target: :_blank, class: "icon-btn", title: "Visit" do %>
  <%# icon SVG %>
<% end %>
```

---

## Forms & Inputs

### Labels and sections

```erb
<div class="form-section">
  <div class="p-4">
    <%= form.label :name, class: "form-label" %>
    <%= form.text_area :name, class: "block w-full base-input", required: true, rows: 2 %>
  </div>
</div>
```

### Error box

Wrap validation errors in `.error-box`:

```erb
<div class="error-box">
  <%= render("project/tasks/form_errors", resource: @task) %>
</div>
```

### Text input

```erb
<%= f.email_field :email, autofocus: true, autocomplete: "email",
    required: true, class: "base-input block w-full" %>
```

### Checkbox

```erb
<%= f.check_box :remember_me, class: "checkbox mr-1", checked: true %>
```

### Radio buttons

```erb
<%= f.radio_button :dark_mode, :on,   class: "h-4 w-4 radio" %>
<%= f.radio_button :dark_mode, :off,  class: "h-4 w-4 radio" %>
<%= f.radio_button :dark_mode, :auto, class: "h-4 w-4 radio" %>
```

### File input

```erb
<%= f.file_field :avatar, accept: allowed_img_file_types,
    class: "appearance-none file-select text-sm leading-tight
           file:mr-3 file:py-2 file:px-3 file:rounded-md
           file:border-0 file:text-sm file:font-medium w-full" %>
```

Dark mode for `.file-select` is handled automatically via `@media (prefers-color-scheme: dark)` and `.dark`/`.light` class selectors in the CSS.

---

## Tabs

Tabs are rendered via the `render_tabs` helper in `ApplicationHelper`, which uses CSS helper methods from `CssHelper`:

```ruby
# app/helpers/css_helper.rb
def ui_tabs      = "tab-container"
def ui_tab       = "tab"
def ui_active_tab = "tab-active #{theme_text}"
```

Usage in views (via project-specific helper):

```erb
<%= project_tabs @project, @tab_name %>
```

Or the home page variant:

```erb
<%= home_tabs "Projects" %>
```

Direct usage:

```erb
<nav class="flex nav-tabs <%= ui_tabs %>">
  <%= link_to "Tasks", project_tasks_path(@project), class: ui_active_tab %>
  <%= link_to "Files", project_files_path(@project), class: ui_tab %>
</nav>
```

---

## Flash Messages

Flash messages are rendered via the `display_flash` helper:

```ruby
# app/helpers/application_helper.rb
def display_flash
  if alert
    content_tag(:p, alert, id: "notice", class: "flash-alert p-3 text-sm mb-2")
  elsif notice
    content_tag(:p, notice, id: "alert", class: "flash-notice p-3 text-sm mb-2")
  end
end
```

Called in views:

```erb
<%= display_flash %>
```

---

## Resource Containers

The resource-* classes form the standard card pattern used throughout the app.

### Full card with header, list, and empty state

```erb
<div class="resource-container">
  <div class="resource-header">
    <div>
      <h3 class="resource-title">Project Links</h3>
    </div>
    <div>
      <%= link_to "Add Link", new_project_link_path(@project), class: "btn-base" %>
    </div>
  </div>

  <div class="bg-base">
    <% if @project.links.any? %>
      <ul role="list" class="resource-list">
        <% @project.links.each do |link| %>
          <%= render "project/links/link", link: link %>
        <% end %>
      </ul>
    <% else %>
      <div class="resource-empty-state">
        <svg class="resource-empty-icon" ...></svg>
        <h3 class="resource-empty-title">No links</h3>
        <p class="resource-empty-description">
          Get started by adding your first project link.
        </p>
        <div class="resource-empty-action">
          <%= link_to new_project_link_path(@project), class: "btn-base" do %>
            Add a link
          <% end %>
        </div>
      </div>
    <% end %>
  </div>
</div>
```

### Card with body (no list)

```erb
<div class="resource-container">
  <div class="resource-body">
    <%# form or content %>
  </div>
</div>
```

### Subtitle and description

```erb
<h4 class="resource-subtitle">Section Name</h4>
<p class="resource-description">Additional context about this section.</p>
```

---

## Lists & Data Display

### Data rows (key-value pairs)

Used in settings and admin views inside a `.form-section`:

```erb
<div class="form-section">
  <div class="data-row">
    <dt class="data-label">Email</dt>
    <dd class="text-sm text-default"><%= @user.email %></dd>
  </div>
  <div class="data-row">
    <dt class="data-label">Created</dt>
    <dd class="text-sm text-default"><%= @user.created_at.to_date %></dd>
  </div>
</div>
```

### List rows (item with actions)

Used inside `.resource-list` items:

```erb
<li id="<%= dom_id link %>">
  <div class="list-row">
    <div class="flex items-center min-w-0">
      <div class="list-item-content">
        <%= link_to link.url, class: "link-primary list-text-primary truncate" do %>
          <%= link.safe_title %>
        <% end %>
        <div class="mt-1 flex items-center list-text-secondary">
          <%= link.url.truncate(50) %>
        </div>
      </div>
    </div>
    <div class="list-item-actions">
      <%= link_to link.url, target: :_blank, class: "icon-btn", title: "Visit" do %>
        <%# icon SVG %>
      <% end %>
    </div>
  </div>
</li>
```

---

## Tasks

### Task item with checkbox

Tasks use `.checkbox-round` for the toggle and conditional `.task-done`/`.task-todo` styling:

```erb
<%= turbo_frame_tag dom_id(task), class: (task.done ? "task task-done" : "task task-todo") do %>
  <%= form_with model: [task.project, task], method: :patch do |form| %>
    <%= form.check_box :done,
        checked: task.done,
        class: "w-5 h-5 checkbox-round flex",
        onchange: "this.form.requestSubmit()" %>
  <% end %>

  <%= link_to details_project_task_path(task.project, task),
      data: { turbo: false }, class: "min-w-0 grow flex h-12 items-center mr-2" do %>
    <p class="task-name min-w-0"><%= task.name %></p>
  <% end %>
<% end %>
```

### Overdue indicator

```erb
<% if !task.done? && task.due_date < Date.current %>
  <span class="status-dot-overdue" title="Overdue task"></span>
<% end %>
```

Also used at the project level:

```erb
<% if project.overdue_tasks? %>
  <span class="status-dot-overdue ml-2 align-middle" title="Overdue tasks"></span>
<% end %>
```

---

## Typography & Text

### Muted text

```erb
<time class="text-xs text-muted"><%= time_ago_short record.created_at %></time>
```

### Text hierarchy in lists

```erb
<h3 class="list-text-primary font-semibold truncate"><%= project.name %></h3>
<div class="mt-1 list-text-secondary truncate">Created by <%= project.user.email %></div>
```

### Secondary text

```erb
<div class="text-secondary space-y-1">
  <div class="flex items-baseline">
    <span class="w-24 shrink-0">Assigned:</span>
    <span><%= task.assigned_user.email %></span>
  </div>
</div>
```

### Comment body

```erb
<div class="comment-body">
  <%= format_user_content(comment.body) %>
</div>
```

Links inside `.comment-body` are automatically styled with violet underline.

---

## Utilities

### Avatar background

```erb
<%= avatar_tag(current_user, "h-8 w-8 avatar-bg") %>
```

The `avatar_bg` class provides a gray circular background. Size is controlled by additional Tailwind width/height classes.

### Links

```erb
<%= link_to @project.user.email,
    project_tasks_path(@project, assigned: @project.user),
    class: "link-primary list-text-primary truncate" %>
```

### Round checkbox (task toggle)

```erb
<%= form.check_box :done,
    checked: @task.done,
    class: "w-5 h-5 checkbox-round mr-2",
    onchange: "this.form.requestSubmit()" %>
```
