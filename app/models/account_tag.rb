class AccountTag < ApplicationRecord
  belongs_to :account
  belongs_to :tag
end
