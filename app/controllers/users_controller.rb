# frozen_string_literal: true

# Controlador para gestionar acciones relacionadas con usuarios
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy update_basic_info search_name]
  before_action :logged_in_user, only: %i[index edit update destroy update_basic_info]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_or_correct_user, only: :show
  before_action :admin_user, only: %i[destroy update_basic_info index]
  before_action :set_one_month, only: :show

  def search_name
    @users = User.where('name LIKE ?', "%#{params[:name]}%")
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info; end

  def update_basic_info
    User.find_each do |user|
      if user.update(basic_info_params)
        flash[:success] = '基本情報を更新しました。'
      else
        flash[:danger] = "更新は失敗しました。<br>#{user.errors.full_messages.join('<br>')}"
      end
    end
    redirect_to user_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end

  def basic_info_params
    params.require(:user).permit(:basic_time, :work_time)
  end
end
