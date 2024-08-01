class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :trackable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
