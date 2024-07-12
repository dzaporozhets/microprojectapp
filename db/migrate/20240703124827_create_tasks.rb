class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.boolean :done, null: false, default: false

      t.timestamps
    end

    add_index :tasks, [:user_id, :done]
    add_index :tasks, [:project_id, :done]
  end
end
