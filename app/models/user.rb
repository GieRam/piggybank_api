# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_accounts
  has_many :accounts, through: :user_accounts

  validates :name, length: { minimum: 2, maximum: 255 }, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
