module ProjectsHelper
  def project_tabs(selected = nil)
    tabs = [
      #{ name: 'Project', path: '#' },
      { name: 'Tasks', path: project_path(@project) },
      { name: 'Notes', path: project_notes_path(@project) },
      { name: 'Files', path: project_files_path(@project) }
    ]

    tabs << { name: 'Team', path: project_activity_path(@project) } unless @project.personal?
    #tabs << { name: 'Settings', path: edit_project_path(@project) } if @project.user == current_user

    render_tabs(tabs, selected)
  end
end
