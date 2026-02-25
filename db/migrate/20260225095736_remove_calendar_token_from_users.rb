class RemoveCalendarTokenFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, :calendar_token
    remove_column :users, :calendar_token, :string
  end
end
