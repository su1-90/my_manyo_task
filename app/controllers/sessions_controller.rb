class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  skip_before_action :require_login, only: [:new, :create,]
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      @current_user = user
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end
  

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: 'ログアウトしました'
  end

  private

  def redirect_if_logged_in
    if logged_in?
      flash[:alert] = 'ログアウトしてください'
      redirect_to tasks_path
    end
  end
end
