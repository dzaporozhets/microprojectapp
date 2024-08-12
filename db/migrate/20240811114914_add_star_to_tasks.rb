class AddStarToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :star, :boolean, null: false, default: false
  end
end
