# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'Account Name' }
    description { 'Joint savings account' }

    trait :with_user do
      after :create do |account|
        account.users << create(:user)
      end
    end
  end
end