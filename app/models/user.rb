# frozen_string_literal: true

# jhgjhg
class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  attr_accessor :skip_validations

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }, unless: :skip_validations

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    unless: :skip_validations
  validates :department, length: { in: 2..30 }, allow_blank: true, unless: :skip_validations
  validates :basic_time, presence: true, unless: :skip_validations
  validates :work_time, presence: true, unless: :skip_validations
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, unless: :skip_validations

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

  def remember
    self.remember_token = User.new_token
    self.skip_validations = true
    update_columns(remember_digest: User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    self.skip_validations = true
    update_columns(remember_digest: nil)
  end
end
