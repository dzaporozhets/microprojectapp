module ProjectsHelper
  def project_tabs(project, selected = nil)
    tabs = [
      { name: 'Tasks', path: project_path(project) },
      { name: 'Notes', path: project_notes_path(project) },
      { name: 'Project', path: overview_project_path(project) }
    ]

    render_tabs(tabs, selected)
  end

  def project_nav_class(active)
    [
      "flex items-center justify-between px-3 py-2 text-gray-600 dark:text-gray-400 font-base",
      active ? subnav_active_tab : "btn-tab"
    ].join(" ")
  end
end
