class ChangeObjectChangesToJsonb < ActiveRecord::Migration[7.1]
  def up
    change_column :versions, :object_changes, :jsonb, using: 'object_changes::jsonb'
    change_column :versions, :object, :jsonb, using: 'object::jsonb'
  end

  def down
    change_column :versions, :object_changes, :text
    change_column :versions, :object, :text
  end
end
