class NotesController < ApplicationController
  def index
    @notes = Note.where(project_id: current_user.all_active_projects)
                 .includes(:project, :user)
                 .order(id: :desc)
                 .page(params[:page]).per(100)

    @pinned_project_ids = current_user.pins.pluck(:project_id).to_set
  end
end
