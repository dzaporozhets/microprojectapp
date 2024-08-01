module ProjectsHelper
  def project_tabs(selected = nil)
    tabs = [
      { name: 'Tasks', path: project_path(@project) },
      { name: 'Schedule', path: project_schedule_path(@project) }
    ]

    unless @project.personal?
      tabs << { name: 'Activity', path: project_activity_path(@project) }
    end

    render_tabs(tabs, selected)
  end
end
