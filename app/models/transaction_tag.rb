class TransactionTag < ApplicationRecord
  belongs_to :transaction
  belongs_to :tag
end
