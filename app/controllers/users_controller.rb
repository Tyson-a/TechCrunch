class UsersController < ApplicationController
  before_action :authorize_user, only: [:show, :edit, :update]
  before_action :check_user, only: [:orders]

  def orders
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
  end


  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end



  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless @user == current_user
  end


def check_user
  redirect_to root_path, alert: "Not authorized" if current_user.id != params[:id].to_i
end


end
