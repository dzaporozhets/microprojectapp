class RemoveNoteIdFromTasks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tasks, :note_id, :bigint
  end
end
