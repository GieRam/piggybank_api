# frozen_string_literal: true

RSpec.describe Account do
  let(:account) { create(:account) }

  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
end