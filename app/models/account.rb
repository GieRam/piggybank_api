# frozen_string_literal: true

class Account < ApplicationRecord
  validates :name, length: { minimum: 2, maximum: 50 }, presence: true, uniqueness: true

  has_many :user_accounts, dependent: :destroy
  has_many :users, through: :user_accounts
end
