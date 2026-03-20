class RemoveProjectFilesFromProjects < ActiveRecord::Migration[7.2]
  def up
    remove_column :projects, :project_files, if_exists: true
  end

  def down
    add_column :projects, :project_files, :json
  end
end
