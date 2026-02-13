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

  def project_nav_link(path, label, count = nil, compact: false)
    link_to path, class: "flex flex-col bg-gray-400/5 p-6 dark:bg-white/5" do
      content = tag.dt(label, class: "text-xs/5 font-semibold text-gray-600 dark:text-gray-300")

      unless compact
        content += tag.dd(count, class: "order-first text-2xl font-semibold tracking-tight text-gray-900 dark:text-white")
      end

      content
    end
  end
end
