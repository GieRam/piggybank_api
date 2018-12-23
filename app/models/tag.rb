class Tag < ApplicationRecord
  validates :name, length: { maximum: 255 }
end
