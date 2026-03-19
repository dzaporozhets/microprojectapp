class MigrateProjectFilesToNotes < ActiveRecord::Migration[7.2]
  def up
    # Skip if project_files column no longer exists (already cleaned up)
    return unless column_exists?(:projects, :project_files)

    execute("SELECT id, user_id, project_files FROM projects WHERE project_files IS NOT NULL AND project_files != '[]'").each do |row|
      project_id = row['id']
      user_id = row['user_id']
      filenames = JSON.parse(row['project_files']) rescue next

      next if filenames.empty?

      content = filenames.map { |f|
        download_path = "/projects/#{project_id}/files/download?file=#{CGI.escape(f)}"
        "#{f} - #{download_path}"
      }.join("\n")

      Note.create!(
        project_id: project_id,
        user_id: user_id,
        title: "Files",
        content: content
      )
    end
  end

  def down
    Note.where(title: "Files").destroy_all
  end
end
