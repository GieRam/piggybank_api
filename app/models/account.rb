class Account < ApplicationRecord
  has_many :account_tags, inverse_of: :account
  has_many :tags, through: :account_tags
  has_many :transactions

  validates :name, length: { min: 2, maximum: 255 }
end
