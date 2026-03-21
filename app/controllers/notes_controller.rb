class NotesController < ApplicationController
  def index
    @notes = Note.where(project_id: current_user.all_active_projects)
                 .includes(:project, :user)
                 .order(id: :desc)
                 .page(params[:page]).per(100)

  end
end
