class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :confirmable

  layout 'admin'

  def index
    @users = User.order(id: :desc).page(params[:page]).per(50)
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def confirmable
    @confirmable ||= !User.skip_email_confirmation?
  end
end
