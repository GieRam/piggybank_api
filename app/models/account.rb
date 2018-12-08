class Account < ApplicationRecord
  has_many :account_tags
  has_many :tags, through: :account_tags
end
