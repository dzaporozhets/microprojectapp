class AddStarToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :star, :boolean, null: false, default: false
  end
end
