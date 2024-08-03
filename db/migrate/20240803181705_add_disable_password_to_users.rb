class AddDisablePasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :disable_password, :boolean, null: false, default: false
  end
end
