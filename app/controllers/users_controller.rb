class UsersController < ApplicationController
  before_filter :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action  :verify_authorized

  def index
    @users = User.all
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted"
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, notice: "User updated"
    else
      redirect_to users_path, alert: "Unable to update user"
    end
  end

  private
    def secure_params
      params.require(:user).permit(:role)
    end
end