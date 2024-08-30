class AddAssignedUserIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :assigned_user, foreign_key: { to_table: :users }, index: true
  end
end
