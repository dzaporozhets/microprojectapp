class AddDocumentIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :document, foreign_key: true
  end
end
