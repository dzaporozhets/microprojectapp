class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  layout 'admin'

  def index
    @users = User.order(id: :desc).page(params[:page]).per(50)
  end
end
