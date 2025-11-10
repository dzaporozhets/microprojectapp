class Project::ExportController < Project::BaseController
  before_action :project_owner_only!

  def new
  end

  def create
    export_service = ProjectExportService.new(project)

    respond_to do |format|
      format.json do
        send_data export_service.export_data.to_json,
                  filename: export_service.filename,
                  type: 'application/json',
                  disposition: 'attachment'
      end
    end
  end
end
