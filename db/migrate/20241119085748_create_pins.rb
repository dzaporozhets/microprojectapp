class CreatePins < ActiveRecord::Migration[7.1]
  def change
    create_table :pins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end

    add_index :pins, [:user_id, :project_id], unique: true
  end
end
