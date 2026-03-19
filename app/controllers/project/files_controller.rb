class Project::FilesController < Project::BaseController
  def download
    file = project.project_files.find { |f| f.identifier == params[:file] }

    if file
      if ENV['AWS_S3_BUCKET'].present?
        send_data file.read, filename: file.identifier, type: file.content_type, disposition: 'attachment'
      else
        send_file file.file.path, filename: file.file.identifier, type: file.file.content_type, disposition: 'attachment'
      end
    else
      redirect_to project_path(project), alert: 'File not found.'
    end
  end
end
