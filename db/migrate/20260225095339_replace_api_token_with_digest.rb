class ReplaceApiTokenWithDigest < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :api_token_digest, :string
    add_column :users, :api_token_last8, :string
    add_index :users, :api_token_digest, unique: true

    remove_index :users, :api_token
    remove_column :users, :api_token, :string
  end
end
