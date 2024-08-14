class AddDarkModeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dark_mode, :integer, null: false, default: 2
  end
end
