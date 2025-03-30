module ProjectsHelper
  def project_tabs(selected = nil)
    tabs = [
      #{ name: 'Project', path: '#' },
      { name: 'Tasks', path: project_path(@project) },
      { name: 'Notes', path: project_notes_path(@project) },
      { name: 'Project', path: overview_project_path(@project) }
      #{ name: 'Files', path: project_files_path(@project) }
    ]

    #tabs << { name: 'Team', path: project_activity_path(@project) } unless @project.personal?
    #tabs << { name: 'Settings', path: edit_project_path(@project) } if @project.user == current_user

    render_tabs(tabs, selected)
  end

  def overview_nav_link(name, path, active)
    classes = [
      "group flex items-center px-3 py-2 text-sm font-medium rounded-md",
      active ? "bg-violet-100 text-violet-900 dark:bg-violet-800 dark:text-white" : "text-gray-600 hover:bg-gray-100 hover:text-gray-900 dark:text-gray-300 dark:hover:bg-gray-700 dark:hover:text-white"
    ].join(" ")

    link_to name, path, class: classes
  end
end
