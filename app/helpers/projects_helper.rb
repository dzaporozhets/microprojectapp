module ProjectsHelper
  def project_tabs(selected = nil)
    render_tabs([
        { name: 'Tasks', path: project_path(@project) },
        #{ name: 'Tasks', path: project_tasks_path(@project) },
        { name: 'Schedule', path: project_path(@project) }
      ], selected)
  end
end
