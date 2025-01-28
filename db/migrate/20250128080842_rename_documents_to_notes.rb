class RenameDocumentsToNotes < ActiveRecord::Migration[7.1]
  def change
     rename_table :documents, :notes
     rename_column :tasks, :document_id, :note_id
  end
end
