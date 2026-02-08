module ProjectsHelper
  def project_tabs(project, selected = nil)
    tabs = [
      { name: 'Project', path: project_path(project) },
      { name: 'Tasks', path: project_tasks_path(project) }
    ]

    unless project.personal?
      tabs << { name: 'Team', path: project_users_path(project) }
    end

    if project.user == current_user
      tabs << { name: 'Settings', path: edit_project_path(project) }
    end

    render_tabs(tabs, selected)
  end
end
