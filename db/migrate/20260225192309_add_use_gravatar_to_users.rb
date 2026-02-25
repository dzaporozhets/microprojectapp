class AddUseGravatarToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :use_gravatar, :boolean, default: false, null: false
  end
end
