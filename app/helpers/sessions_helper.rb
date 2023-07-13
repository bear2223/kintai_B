# frozen_string_literal: true

# module SessionsHelper
#   # 引数に渡されたユーザーオブジェクトでログインします。
#   def log_in(user)
#     session[:user_id] = user.id
#   end

#   # 永続的セッションを記憶します（Userモデルを参照）
#   def remember(user)
#     user.remember
#     cookies.permanent.signed[:user_id] = user.id
#     cookies.permanent[:remember_token] = user.remember_token
#   end

#   # 永続的セッションを破棄します
#   def forget(user)
#     user.forget # Userモデル参照
#     cookies.delete(:user_id)
#     cookies.delete(:remember_token)
#   end

#   # セッションと@current_userを破棄します
#   def log_out
#     forget(current_user)
#     session.delete(:user_id)
#     @current_user = nil
#   end

#   # 一時的セッションにいるユーザーを返します。
#   # それ以外の場合はcookiesに対応するユーザーを返します。
#   # def current_user
#   #   if (user_id = session[:user_id])
#   #     @current_user ||= User.find_by(id: user_id)
#   #   elsif (user_id = cookies.signed[:user_id])
#   #     user = User.find_by(id: user_id)
#   #     if user && user.authenticated?(cookies[:remember_token])
#   #       log_in user
#   #       @current_user = user
#   #     end
#   #   end
#   # end

#   def current_user
#     if (user_id = session[:user_id])
#       @current_user ||= User.find_by(id: user_id)
#     elsif (user_id = cookies.signed[:user_id])
#       user = User.find_by(id: user_id)
#       if user&.authenticated?(cookies[:remember_token])
#         log_in user
#         @current_user = user
#       end
#     end
#   end

#   # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
#   def current_user?(user)
#     user == current_user
#   end

#   # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
#   def logged_in?
#     !current_user.nil?
#   end

#   # 記憶しているURL(またはデフォルトURL)にリダイレクトします。
#   def redirect_back_or(default_url)
#     redirect_to(session[:forwarding_url] || default_url)
#     session.delete(:forwarding_url)
#   end

#   # アクセスしたいURLを記憶します。
#   def store_location
#     session[:forwarding_url] = request.original_url if request.get?
#   end
# end

# module SessionsHelper
#   def log_in(user)
#     session[:user_id] = user.id
#   end

#   def remember(user)
#     user.remember
#     cookies.permanent.signed[:user_id] = user.id
#     cookies.permanent[:remember_token] = user.remember_token
#   end

#   def forget(user)
#     user.forget
#     cookies.delete(:user_id)
#     cookies.delete(:remember_token)
#   end

#   def log_out
#     forget(current_user)
#     session.delete(:user_id)
#     @current_user = nil
#   end

#   def current_user
#     @current_user ||= User.find_by(id: session[:user_id])
#     if @current_user.nil? && (user_id = cookies.signed[:user_id])
#       user = User.find_by(id: user_id)
#       if user&.authenticated?(cookies[:remember_token])
#         log_in(user)
#         @current_user = user
#       end
#     end
#     @current_user
#   end

#   def current_user?(user)
#     user == current_user
#   end

#   def logged_in?
#     !current_user.nil?
#   end

#   def redirect_back_or(default_url)
#     redirect_to(session.delete(:forwarding_url) || default_url)
#   end

#   def store_location
#     session[:forwarding_url] = request.original_url if request.get?
#   end
# end

# jhkjh
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
  end

  # def current_user
  #   if (user_id = session[:user_id])
  #     User.find_by(id: user_id)
  #   elsif (user_id = cookies.signed[:user_id])
  #     user = User.find_by(id: user_id)
  #     if user&.authenticated?(cookies[:remember_token])
  #       log_in(user)
  #       user
  #     end
  #   end
  # end

  def current_user
    if (user_id = session[:user_id])
      User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      find_user_by_cookie(user_id)
    end
  end

  def find_user_by_cookie(user_id)
    user = User.find_by(id: user_id)
    return unless user&.authenticated?(cookies[:remember_token])

    log_in(user)
    user
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def redirect_back_or(default_url)
    redirect_to(session.delete(:forwarding_url) || default_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def round_to_quarter(minutes)
    case minutes
    when 0..14
      0
    when 15..29
      15
    when 30..44
      30
    else
      45
    end
  end
end
