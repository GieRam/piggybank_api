class Tag < ApplicationRecord
  has_many :transaction_tags, inverse_of: :transaction
  has_many :transactions, through: :transaction_tags

  validates :name, length: { maximum: 255 }, uniqueness: true
end
