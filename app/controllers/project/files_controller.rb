class Project::FilesController < Project::BaseController
  def index
    @files = project.project_files
    @tab_name = 'Files'
  end

  def new
  end

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

  def create
    add_more_files(params[:project][:project_files])

    if project.save
      redirect_to project_files_path(project), notice: 'Files were successfully uploaded.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    remove_file(params[:file])

    project.save

    respond_to do |format|
      format.html { redirect_to project_files_url(@project) }
      format.json { head :no_content }
    end
  end

  private

  def project_params
    params.require(:project).permit({project_files: []})
  end

  def add_more_files(new_files)
    existing_files = project.project_files || []
    project.project_files = existing_files.map(&:identifier) + new_files
  end

  def remove_file(file_name)
    remain_project_files = project.project_files.reject { |f| f.identifier == file_name }

    if remain_project_files.size != project.project_files.size
      project.project_files = remain_project_files.map(&:identifier)
    end
  end
end
