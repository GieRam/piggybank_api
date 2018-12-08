class Transaction < ApplicationRecord
  enum type: %i[fixed periodic]
  has_many :transaction_tags
  has_many :tags, through: :transaction_tags
end
