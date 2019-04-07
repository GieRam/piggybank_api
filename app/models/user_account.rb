# frozen_string_literal: true

class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :account
end
