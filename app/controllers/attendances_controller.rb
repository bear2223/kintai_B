# frozen_string_literal: true

# hggj
class AttendancesController < ApplicationController
  before_action :set_user, only: %i[edit_one_month update_one_month]
  before_action :logged_in_user, only: %i[update edit_one_month]
  before_action :admin_or_correct_user, only: %i[update edit_one_month update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = '勤怠登録に失敗しました。やり直してください。'

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      update_attendance(:started_at, 'おはようございます！')
    elsif @attendance.finished_at.nil?
      update_attendance(:finished_at, 'お疲れ様でした。')
    end
    redirect_to user_path(id: params[:user_id])
  end

  def edit_one_month; end

  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.assign_attributes(item)
        attendance.save!(context: :editt)
      end
    end
    flash[:success] = '1ヶ月分の勤怠情報を更新しました。'
    redirect_to user_path(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = '無効な入力データがあった為、更新をキャンセルしました。'
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  private

  def attendances_params
    params.require(:user).permit(attendances: %i[started_at finished_at note])[:attendances]
  end

  def update_attendance(column, message)
    if @attendance.update(column => Time.current.change(sec: 0))
      flash[:info] = message
    else
      flash[:danger] = UPDATE_ERROR_MSG
    end
  end
end
