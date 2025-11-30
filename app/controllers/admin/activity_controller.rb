class Admin::ActivityController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  layout 'admin'

  def index
    @records = Activity.includes(:user, :project).order(id: :desc).limit(40)

    @tab_name = 'Activity'
  end
end
