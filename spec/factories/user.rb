# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'Test' }
    email { 'test@mail.com' }
    password { 'Test123!' }
    password_confirmation { 'Test123!' }

    trait :with_password_reset do
      after(:create, &:create_reset_digest)
    end

    trait :with_refresh_token do
      after(:create, &:set_refresh_token)
    end

    trait :active do
      after(:create, &:activate)
    end
  end
end
