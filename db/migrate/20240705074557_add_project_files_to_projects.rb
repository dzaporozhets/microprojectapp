class AddProjectFilesToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :project_files, :json
  end
end
