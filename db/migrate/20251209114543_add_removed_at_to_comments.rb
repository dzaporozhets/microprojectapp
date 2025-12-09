class AddRemovedAtToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :removed_at, :datetime
    add_index :comments, :removed_at
  end
end
