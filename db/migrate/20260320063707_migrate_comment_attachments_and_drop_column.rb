class MigrateCommentAttachmentsAndDropColumn < ActiveRecord::Migration[7.2]
  def up
    return unless column_exists?(:comments, :attachment)

    rows = execute(<<-SQL)
      SELECT c.id AS comment_id, c.attachment, c.user_id, t.project_id
      FROM comments c
      JOIN tasks t ON t.id = c.task_id
      WHERE c.attachment IS NOT NULL AND c.attachment != ''
    SQL

    # Group by project to create one note per project
    by_project = {}
    rows.each do |row|
      project_id = row['project_id']
      by_project[project_id] ||= { user_id: row['user_id'], files: [] }
      by_project[project_id][:files] << row['attachment']
    end

    by_project.each do |project_id, data|
      content = data[:files].map { |f| "Comment attachment: #{f}" }.join("\n")

      Note.create!(
        project_id: project_id,
        user_id: data[:user_id],
        title: "Comment attachments",
        content: content
      )
    end

    remove_column :comments, :attachment
  end

  def down
    add_column :comments, :attachment, :string unless column_exists?(:comments, :attachment)
  end
end
