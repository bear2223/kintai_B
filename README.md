views/users/_edit_basic_info.html.erb

<% provide(:class_text, 'basic-info') %>
<% provide(:button_text, '更新') %>

<div class="modal-dialog modal-lg modal-dialog-center">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">×</span>
      </button>
      <h1 class="modal-title">基本情報編集</h1>
    </div>
    <div class="modal-body">
      <div class="row">
        <div class="col-md-6 col-md-offset-3">
          <%= form_with(model: @user, url: update_basic_info_user_path(@user), local: true, method: :patch) do |f| %>
            <%= render 'shared/error_messages', object: @user %>

            <%= f.label :name, class: "label-#{yield(:class_text)}" %>
            <p><%= @user.name %></p>

            <%= f.label :department, class: "label-#{yield(:class_text)}" %>
            <%= f.text_field :department, class: "form-control" %>

            <%= f.label :basic_time, class: "label-#{yield(:class_text)}" %>
            <%= f.time_field :basic_time, class: "form-control" %>

            <%= f.label :work_time, class: "label-#{yield(:class_text)}" %>
            <%= f.time_field :work_time, class: "form-control" %>

            <div class="center">
              <%= f.submit yield(:button_text), class: "btn btn-primary btn-#{yield(:class_text)}" %>
              <button type="button" class="btn btn-default btn-<%= yield(:class_text) %>" data-dismiss="modal">
                キャンセル
              </button>
            </div>
          <% end %>
        </div>
      </div>
    </div>
  </div>
</div>
###################################################################
views/users/index.html

<% provide(:title, 'All Users') %>
<h1>ユーザー一覧</h1>

<div class="col-md-10 col-md-offset-1">
  <%= will_paginate %>
  <table class="table table-condensed table-hover" id="table-users">
    <thead>
      <tr>
        <th><%= User.human_attribute_name :name %></th>
        <th class="center"><%= User.human_attribute_name :department %></th>
        <% if current_user.admin? %>
          <th class="center"><%= User.human_attribute_name :basic_time %></th>
          <th class="center"><%= User.human_attribute_name :work_time %></th>
        <% end %>
        <th></th>
      </tr>
    </thead>

    <% @users.each do |user| %>
      <tr>
        <td>
          <% if current_user.admin? %>
            <%= link_to user.name, user %>
          <% else %>
            <%= user.name %>
          <% end %>
        </td>
        <td class="center"><%= user.department.present? ? user.department : "未所属" %></td>
        <% if current_user.admin? %>
          <td class="center"><%= format_basic_info(user.basic_time) %></td>
          <td class="center"><%= format_basic_info(user.work_time) %></td>
        <% end %>
        <td class="center">
          <% if current_user.admin? && !current_user?(user) %>
            <%= link_to "基本情報編集", edit_basic_info_user_path(user), remote: true, class: "btn btn-success" %>
            <%= link_to "削除", user, method: :delete,
                data: { confirm: "削除してよろしいですか？" }, class: "btn btn-danger" %>
          <% end %>
        </td>
      </tr>
    <% end %>
  </table>
  <%= will_paginate %>
</div>

<!--モーダルウインドウ表示-->
<!--<div id="edit-basic-info" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"></div>-->

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
views/users/show.html

<% provide(:title, @user.name) %>
<div>
  <table class="table table-bordered table-condensed user-table">
    <tr>
      <td>【<%= l(@first_day, format: :middle) %>】勤怠管理表</td>
      <td>指定勤務時間：<%= format_basic_info(@user.work_time) %></td>
      <td>基本時間：<%= format_basic_info(@user.basic_time) %></td>
      <td>月初日：<%= l(@first_day, format: :short) %></td>
    </tr>
    <tr>
      <td>所属：<%= @user.department.present? ? @user.department : "未所属" %></td>
      <td>名前：<%= @user.name %></td>
      <td>出勤日数：<%= @worked_sum %>日</td>
      <td>月末日：<%= l(@last_day, format: :short) %></td>
    </tr>
  </table>
</div>
<div class="btn-users-show">
  <!--<%= link_to "⇦ 前月へ", user_path(date: @first_day.prev_month), class: "btn btn-info" %>-->
  <!--<%= link_to "1ヶ月の勤怠編集へ", attendances_edit_one_month_user_path(date: @first_day), class: "btn btn-success" %>-->
  <!--<%= link_to "次月へ ⇨", user_path(date: @first_day.next_month), class: "btn btn-info" %>-->
  <%= link_to "勤怠を編集", attendances_edit_one_month_user_path(date: @first_day), class: "btn btn-info" %>
</div>
<div>
  <table class="table table-bordered table-condensed table-hover" id="table-attendances">
    <thead>
      <tr>
        <th>日付</th>
        <th>曜日</th>
        <th>勤怠登録</th>
        <th>出勤時間</th>
        <th>退勤時間</th>
        <th>在社時間</th>
        <th>備考</th>
      </tr>
    </thead>
    <tbody>
      <% @attendances.each do |day| %>
        <tr>
          <td><%= l(day.worked_on, format: :short) %></td>
          <!--<td><%= $days_of_the_week[day.worked_on.wday] %></td>-->
          <td><%= ApplicationController::DAYS_OF_THE_WEEK[day.worked_on.wday] %></td>
          <td>
            <% if btn_text = attendance_state(day) %>
              <%= link_to "#{btn_text}登録", user_attendance_path(@user, day), method: :patch, class: "btn btn-primary btn-attendance" %>
            <% end %>
          </td>
          <td><%= l(day.started_at, format: :time) if day.started_at.present? %></td>
          <td><%= l(day.finished_at, format: :time) if day.finished_at.present? %></td>
          <td>
              <% if day.started_at.present? && day.finished_at.present? %>
                <%= str_times = working_times(day.started_at, day.finished_at) %>
                <% @total_working_times = @total_working_times.to_f + str_times.to_f %>
              <% end %>
          </td>
          <td><%= day.note %></td>
        </tr>
      <% end %>
    </tbody>
    
    <tfoot>
      <!--rowspan:縦結合、colspan：横結合-->
      <tr>
        <td colspan="2">累計日数</td>
        <td colspan="2">総合勤務時間</td>
        <td colspan="2">累計在社時間</td>
        <td rowspan="2"></td>
      </tr>
      <tr>
        <td colspan="2"><%= @attendances.count %></td>
        <td colspan="2"><%= format_basic_info(@user.work_time).to_f * @worked_sum %></td>
        <td colspan="2"><%= format("%.2f", @total_working_times.to_f) %></td>
      </tr>
    </tfoot>    
  </table>
</div>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
attendances/edit_one_month.html.erb

<% provide(:title, @user.name) %>
<%= form_with(model: @user, url: attendances_update_one_month_user_path(date: @first_day), local: true, method: :patch) do |f| %>
  <div>
    <h1>勤怠編集画面</h1>
    <table class="table table-bordered table-condensed table-hover" id="table-attendances">
      <thead>
        <tr>
          <th>日付</th>
          <th>曜日</th>
          <th>出勤時間</th>
          <th>退勤時間</th>
          <th>在社時間</th>
          <th>備考</th>
        </tr>
      </thead>
      <tbody>
        <% @attendances.each do |day| %>
          <%= f.fields_for "attendances[]", day do |attendance| %>
            <tr>
              <td><%= l(day.worked_on, format: :short) %></td>
              <td><%= $days_of_the_week[day.worked_on.wday] %></td>
              <% if !current_user.admin? && (Date.current < day.worked_on) %>
                <td><%= attendance.time_field :started_at, readonly: true, class: "form-control" %></td>
                <td><%= attendance.time_field :finished_at, readonly: true, class: "form-control" %></td>
              <% else %>
                <td><%= attendance.time_field :started_at, class: "form-control" %></td>
                <td><%= attendance.time_field :finished_at, class: "form-control" %></td>
              <% end %>
              <td>
                <% if day.started_at.present? && day.finished_at.present? %>
                  <%= working_times(day.started_at, day.finished_at) %>
                <% end %>
              </td>
              <td><%= attendance.text_field :note, class: "form-control" %></td>
            </tr>
          <% end %>
        <% end %>
      </tbody>
    </table>
  </div>

  <div class="center">
    <%= f.submit "まとめて更新", class: "btn btn-lg btn-primary" %>
    <%= link_to "キャンセル", user_path(date: @first_day), class: "btn btn-lg btn-default" %>
  </div>
<% end %>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
app/controllers/users_controller.rb

# frozen_string_literal: true

# Controlador para gestionar acciones relacionadas con usuarios
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy edit_basic_info update_basic_info]
  before_action :logged_in_user, only: %i[index edit update destroy edit_basic_info update_basic_info]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: %i[destroy edit_basic_info update_basic_info]
  before_action :set_one_month, only: :show

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
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to @user
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
    if @user.update(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join('<br>')
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end

  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_time)
  end
end
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
views/layouts/_header.html.erb

<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "勤怠システム", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "トップへ", root_path %></li>
        <% if logged_in? %>
        <% if logged_in? && current_user.admin? %>
          <li><%= link_to "ユーザ一覧", users_path %></li>
          <li><%= link_to "基本情報の修正", "#" %></li>
        <% end %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              アカウント <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
              <li><%= link_to "勤怠", current_user %></li>
              <li><%= link_to "設定", edit_user_path(current_user) %></li>
              <li class="divider"></li>
              <li>
                <%= link_to "ログアウト", logout_path, method: :delete %>
              </li>
            </ul>
          </li>
        <% else %>
          <li><%= link_to "ログイン", login_path %></li>
        <% end %>
      </ul>
    </nav>
  </div>
</header>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
app/controllers/attendances_controller.rb

# frozen_string_literal: true

# hggj
# class AttendancesController < ApplicationController
#   before_action :set_user, only: %i[edit_one_month update_one_month]
#   before_action :logged_in_user, only: %i[update edit_one_month]
#   before_action :admin_or_correct_user, only: %i[update edit_one_month update_one_month]
#   before_action :set_one_month, only: :edit_one_month

#   UPDATE_ERROR_MSG = '勤怠登録に失敗しました。やり直してください。'

#   def update
#     @user = User.find(params[:user_id])
#     @attendance = Attendance.find(params[:id])
#     # 出勤時間が未登録であることを判定します。
#     if @attendance.started_at.nil?
#       if @attendance.update(started_at: Time.current.change(sec: 0))
#         flash[:info] = 'おはようございます！'
#       else
#         flash[:danger] = UPDATE_ERROR_MSG
#       end
#     elsif @attendance.finished_at.nil?
#       if @attendance.update(finished_at: Time.current.change(sec: 0))
#         flash[:info] = 'お疲れ様でした。'
#       else
#         flash[:danger] = UPDATE_ERROR_MSG
#       end
#     end
#     redirect_to @user
#   end

#   def edit_one_month; end

#   def update_one_month
#     ActiveRecord::Base.transaction do # トランザクションを開始します。
#       attendances_params.each do |id, item|
#         attendance = Attendance.find(id)
#         attendance.update!(item)
#       end
#     end
#     flash[:success] = '1ヶ月分の勤怠情報を更新しました。'
#     redirect_to user_url(date: params[:date])
#   rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
#     flash[:danger] = '無効な入力データがあった為、更新をキャンセルしました。'
#     redirect_to attendances_edit_one_month_user_url(date: params[:date])
#   end

#   private

#   # 1ヶ月分の勤怠情報を扱います。
#   def attendances_params
#     params.require(:user).permit(attendances: %i[started_at finished_at note])[:attendances]
#   end
# end

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
    redirect_to show_path
  end

  def edit_one_month; end

  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update!(item)
      end
    end
    flash[:success] = '1ヶ月分の勤怠情報を更新しました。'
    redirect_to user_url(date: params[:date])
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
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
app/models/attendance.rb

# frozen_string_literal: true

# hg
class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, 'が必要です') if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    return unless started_at.present? && finished_at.present?

    errors.add(:started_at, 'より早い退勤時間は無効です') if started_at > finished_at
  end
end
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
models/attendance.rb

if started_at_changed? && !finished_at_changed?
  errors.add(:finished_at, 'と出勤時間を入力してください。')
elsif finished_at_changed? && !started_at_changed?
  errors.add(:started_at, 'と退勤時間を入力してください。')
end
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
def only_started_at_or_only_finished_at_is_invalid
    unless started_at_changed? && finished_at_changed? 
      errors.add(:started_at, 'と退勤時間を入力してください。') if started_at.present? || finished_at.present?
    end
end
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
users/search_name.html.erb

<% provide(:title, 'Names') %>
<h1>検索結果</h1>

<div class="col-md-10 col-md-offset-1">
  <table class="table table-condensed table-hover" id="table-users">
    <% @users.each do |user| %>
      <tr>
        <td>
          <% if current_user.admin? %>
            <%= link_to user.name, user_path(user) %>
          <% else %>
            <%= user.name %>
          <% end %>
        </td>
      </tr>
    <% end %>
  </table>
</div>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
kintai_B/Gemfile
# frozen_string_literal: true

source 'https://rubygems.org'
gem 'bcrypt'
ruby '2.7.6'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
# gem 'bootstrap-will_paginate', '~> 1.0'
gem 'coffee-rails', '~> 4.2'
gem 'faker'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.6'
gem 'rails-i18n'
gem 'rinku'
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'sassc-rails', '>= 2.1.0'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
# gem 'will_paginate'
gem 'will_paginate', '3.3.1'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'sqlite3', '1.3.13'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
kintai_B/db/migrate/20230422102442_add_basic_info_to_users.b

# hjg
class AddBasicInfoToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :basic_time, :datetime, default: -> { Time.current.change(hour: 8, min: 0, sec: 0) }
    add_column :users, :work_time, :datetime, default: -> { Time.current.change(hour: 7, min: 30, sec: 0) }
  end

  def down
    remove_column :users, :basic_time
    remove_column :users, :work_time
  end
end
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
add_column :users, :basic_time, :datetime, default: '08:00:00'
add_column :users, :work_time, :datetime, default: '07:30:00'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

