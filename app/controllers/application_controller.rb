class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user, :admin_user

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin_user
    unless current_user&.admin?
      flash[:alert] = '管理者以外アクセスできません'
      redirect_to tasks_path
    end
  end

  private

  def require_login
    unless logged_in?
      flash[:alert] = 'ログインしてください'
      redirect_to new_session_path
    end
  end
end
