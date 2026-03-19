class MigrateLinksToNotes < ActiveRecord::Migration[7.2]
  def up
    Project.includes(:links).find_each do |project|
      links = project.links.order(:created_at)
      next if links.empty?

      content = links.map { |link|
        line = link.url
        line = "#{link.title} - #{line}" if link.title.present?
        line
      }.join("\n")

      Note.create!(
        project: project,
        user_id: links.first.user_id,
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
