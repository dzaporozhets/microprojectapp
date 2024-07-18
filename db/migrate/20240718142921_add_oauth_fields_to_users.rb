class AddOauthFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :created_from_oauth, :boolean, default: false, null: false
    add_column :users, :oauth_linked_at, :datetime
  end
end
