module ProjectsHelper
  def project_tabs(selected = nil)
    tabs = [
      { name: 'Tasks', path: project_path(@project) },
      { name: 'Schedule', path: project_schedule_path(@project) }
    ]

    render_tabs(tabs, selected)
  end
end
