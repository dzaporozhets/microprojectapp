class AddThemeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :theme, :integer, null: false, default: 1
  end
end
