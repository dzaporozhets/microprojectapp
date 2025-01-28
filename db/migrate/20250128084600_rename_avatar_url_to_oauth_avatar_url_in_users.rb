class RenameAvatarUrlToOauthAvatarUrlInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :avatar_url, :oauth_avatar_url
  end
end
