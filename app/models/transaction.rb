class Transaction < ApplicationRecord
  enum type: %i[fixed periodic]
end
