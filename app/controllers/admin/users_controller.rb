module Admin 
  class Admin::UsersController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    before_action :admin_user
    before_action :set_user, only: [:show, :edit, :update]

    def index
      @users = User.includes(:tasks)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: 'ユーザを登録しました'
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
        redirect_to admin_user_path(@user), notice: 'ユーザを更新しました'
      else
        render :edit
      end
    end
    

    def destroy
      @user = User.find(params[:id]) rescue nil
      if @user.nil?
        redirect_to admin_users_path, notice: 'ユーザは既に削除されています'
      elsif User.where(admin: true).count == 1 && @user.admin?
        @user.errors.add(:base, "管理者が0人になるため削除できません")
        render :show
      else
        @user.destroy
        redirect_to admin_users_path, notice: 'ユーザを削除しました'
      end
    end    

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
  end
end