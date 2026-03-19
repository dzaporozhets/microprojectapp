class MigrateProjectFilesToNotes < ActiveRecord::Migration[7.2]
  def up
    Project.find_each do |project|
      files = project.project_files
      next if files.empty?

      content = files.map { |f|
        filename = f.file.filename
        size = begin
          f.file.size
        rescue StandardError
          nil
        end
        download_path = "/projects/#{project.id}/files/download?file=#{CGI.escape(f.identifier)}"
        line = "#{filename} - #{download_path}"
        line += " (#{ActiveSupport::NumberHelper.number_to_human_size(size)})" if size
        line
      }.join("\n")

      Note.create!(
        project: project,
        user_id: project.user_id,
        title: "Files",
        content: content
      )
    end
  end

  def down
    Note.where(title: "Files").destroy_all
  end
end
