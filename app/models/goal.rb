class Goal < ApplicationRecord
  enum status: %i[active complete rejected]

  has_many :goal_tags
  has_many :tags, through: :goal_tags

  validates :name, length: { minimum: 2, maximum: 255 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
