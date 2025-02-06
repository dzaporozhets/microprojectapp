class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  def index
    @users = User.order(id: :desc).page(params[:page]).per(50)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User updated successfully.'
    else
      flash.now[:alert] = 'Failed to update user.'
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'User deleted successfully.'
    else
      redirect_to admin_users_path, alert: 'Failed to delete user.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:confirmed_at)
  end
end
