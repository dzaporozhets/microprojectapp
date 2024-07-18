class AddArchivedToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :archived, :boolean, null: false, default: false
  end
end
