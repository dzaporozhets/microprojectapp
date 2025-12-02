class AddUpdatedByUserIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks,
                  :updated_by_user,
                  foreign_key: { to_table: :users, on_delete: :nullify },
                  null: true
  end
end
