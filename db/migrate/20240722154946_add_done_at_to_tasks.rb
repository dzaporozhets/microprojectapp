class AddDoneAtToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :done_at, :datetime
  end
end
