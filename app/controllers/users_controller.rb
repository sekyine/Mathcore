class UsersController < ApplicationController
  before_action :require_login

  def options
    @user = current_user
  end

  def update_settings
    @user = current_user
    if @user.update(user_params)
      redirect_to options_users_path, notice: "設定を更新しました"
    else
      render :options, alert: "更新に失敗しました"
    end
  end

  private

  def user_params
    params.require(:user).permit(:math_level)
  end

  def require_login
    unless logged_in?
      redirect_to root_path, alert: "ログインしてください"
    end
  end
end