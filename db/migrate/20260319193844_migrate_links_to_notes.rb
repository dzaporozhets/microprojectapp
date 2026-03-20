class MigrateLinksToNotes < ActiveRecord::Migration[7.2]
  def up
    # Skip if links table no longer exists (already cleaned up)
    return unless table_exists?(:links)

    project_ids = execute("SELECT DISTINCT project_id FROM links").map { |row| row['project_id'] }

    project_ids.each do |project_id|
      rows = execute("SELECT title, url, user_id FROM links WHERE project_id = #{project_id} ORDER BY created_at")

      content = rows.map { |row|
        line = row['url']
        line = "#{row['title']} - #{line}" if row['title'].present?
        line
      }.join("\n")

      Note.create!(
        project_id: project_id,
        user_id: rows.first['user_id'],
        title: "Links",
        content: content
      )
    end

    drop_table :links
  end

  def down
    create_table :links do |t|
      t.string :title
      t.string :url, null: false
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
