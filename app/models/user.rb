# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  # Must contain 6 or more characters
  # Must contain a digit
  # Must contain a lower case character
  # Must contain an upper case character
  VALID_PASSWORD = /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x.freeze

  attr_accessor :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  validates :username, uniqueness: true, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, uniqueness: true,
                    presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true,
                       length: { minimum: 6, maximum: 50 },
                       format: { with: VALID_PASSWORD }

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def auth_token
    JsonWebToken.encode(user_id: id)
  end

  def set_refresh_token
    token = SecureRandom.uuid
    update_column(:refresh_token, token)

    token
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
