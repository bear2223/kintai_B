# frozen_string_literal: true

# # jhg
# class User < ApplicationRecord
#   has_many :attendances, dependent: :destroy
#   # 「remember_token」という仮想の属性を作成します。
#   attr_accessor :remember_token

#   before_save { self.email = email.downcase }

#   validates :name, presence: true, length: { maximum: 50 }

#   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
#   # validates :email, presence: true, length: { maximum: 100 },
#   #                   format: { with: VALID_EMAIL_REGEX },
#   #                   uniqueness: true
#   validates :email, presence: true, length: { maximum: 100 },
#                     format: { with: VALID_EMAIL_REGEX },
#                     uniqueness: { case_sensitive: false }
#   validates :department, length: { in: 2..30 }, allow_blank: true
#   validates :basic_time, presence: true
#   validates :work_time, presence: true
#   has_secure_password
#   validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

#   # 渡された文字列のハッシュ値を返します。
#   # def User.digest(string)
#   #   cost =
#   #     if ActiveModel::SecurePassword.min_cost
#   #       BCrypt::Engine::MIN_COST
#   #     else
#   #       BCrypt::Engine.cost
#   #     end
#   #   BCrypt::Password.create(string, cost: cost)
#   # end

#   def self.digest(string)
#     cost =
#       if ActiveModel::SecurePassword.min_cost
#         BCrypt::Engine::MIN_COST
#       else
#         BCrypt::Engine.cost
#       end
#     BCrypt::Password.create(string, cost: cost)
#   end

#   # ランダムなトークンを返します。
#   # def User.new_token
#   #   SecureRandom.urlsafe_base64
#   # end

#   def self.new_token
#     SecureRandom.urlsafe_base64
#   end

#   # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
#   # def remember
#   #   self.remember_token = User.new_token
#   #   update_attribute(:remember_digest, User.digest(remember_token))
#   # end

#   def remember
#     self.remember_token = User.new_token
#     update_column(:remember_digest, User.digest(remember_token))
#   end

#   # トークンがダイジェストと一致すればtrueを返します。
#   def authenticated?(remember_token)
#     # ダイジェストが存在しない場合はfalseを返して終了します。
#     return false if remember_digest.nil?

#     BCrypt::Password.new(remember_digest).is_password?(remember_token)
#   end

#   # ユーザーのログイン情報を破棄します。
#   # def forget
#   #   update_attribute(:remember_digest, nil)
#   # end

#   def forget
#     update_column(:remember_digest, nil)
#   end
# end

# jhg
class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :department, length: { in: 2..30 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end

  def remember
    self.remember_token = User.new_token
    update_columns(remember_digest: User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # def forget
  #   update_attribute(:remember_digest, nil)
  # end

  def forget
    update_columns(remember_digest: nil)
  end
end
