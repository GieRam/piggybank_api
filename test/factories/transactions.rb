FactoryBot.define do
  factory :transaction do
    amount { 1 }
    type { "" }
    periodic { false }
  end
end
