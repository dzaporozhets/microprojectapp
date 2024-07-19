class AddAttachmentToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :attachment, :string
  end
end
