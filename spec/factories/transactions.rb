FactoryBot.define do
  factory :transaction do
    association :account, factory: :account
    amount { 123.45 }
    source { 0 }
    active_from { Time.current }
    description { 'Description' }
  end
end
