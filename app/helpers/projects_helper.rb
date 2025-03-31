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

  def project_nav_class(active)
    [
      "flex items-center justify-between px-3 py-2 text-gray-600 dark:text-gray-400 font-base",
      active ? subnav_active_tab : "btn-tab"
    ].join(" ")
  end
end
