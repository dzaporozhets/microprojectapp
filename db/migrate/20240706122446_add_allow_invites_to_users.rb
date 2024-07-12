class AddAllowInvitesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :allow_invites, :boolean, null: false, default: true
  end
end
