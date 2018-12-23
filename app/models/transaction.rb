class Transaction < ApplicationRecord
  enum source: %i[fixed periodic]

  has_many :transaction_tags, inverse_of: :tag
  has_many :tags, through: :transaction_tags
  belongs_to :account

  validates :amount, presence: true
  validates :source, presence: true
  validates :description, length: { minimum: 2, maximum: 255 }
  validate :active_from_cant_be_in_past

  def active_from_cant_be_in_past
    return unless active_from.present? && active_from < Date.today

    errors.add(:active_from, "can't be in the past")
  end
end
