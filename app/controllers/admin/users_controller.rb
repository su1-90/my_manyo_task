module Admin 
  class UsersController < ApplicationController
    before_action :require_login
    before_action :require_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.includes(:tasks)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'ユーザを登録しました'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if User.where(admin: true).count == 1 && user_params[:admin] == "0" && @user.admin?
        @user.errors.add(:base, "管理者が0人になるため権限を変更できません")
        render :edit
      elsif @user.update(user_params)
        redirect_to admin_users_path, notice: 'ユーザを更新しました'
      else
        render :edit
      end
    end
    
    def destroy
      if  User.where(admin: true).count == 1 && @user.admin?
        flash[:alert] = "管理者が0人になるため削除できません"
        redirect_to admin_users_path
      else
        @user.destroy
        redirect_to admin_users_path, notice: 'ユーザを削除しました'
      end
    end    

    private

    def set_user
      @user = User.find(params[:id])
    end

    def session_params
      params.require(:session).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def require_admin
      unless current_user.admin?
        flash[:notice] = '管理者以外アクセスできません'
        redirect_to tasks_path
      end
    end
  end
end
