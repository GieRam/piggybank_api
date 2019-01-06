# frozen_string_literal: true

require 'swagger_helper'

describe 'Transactions API' do

  path '/transactions' do
    post 'Creates a transaction' do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          source: { type: :integer },
          active_from: { type: :string },
          account_id: { type: :integer },
          tag_ids: { type: :array, items: { type: :integer } },
          description: { type: :string }
        },
        required: %w[amount source active_from account_id]
      }

      response '201', 'transaction created' do
        let(:account) { create(:account) }
        let(:first_tag) { create(:tag) }
        let(:second_tag) { create(:tag, name: 'Second Tag') }
        let(:transaction) do
          {
            amount: 123.45,
            source: 0,
            active_from: Time.current,
            account_id: account.id,
            tag_ids: [first_tag.id, second_tag.id]
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:account) { create(:account) }
        let(:transaction) { { amount: 123 } }
        run_test!
      end
    end
  end

  path '/transactions/{id}' do
    get 'Retrieves a transaction' do
      tags 'Transactions'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'transaction found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 amount: { type: :number },
                 source: { type: :string },
                 active_from: { type: :string },
                 description: { type: :string }
               },
               required: %w[id amount source active_from]
        let(:id) { create(:transaction).id }
        run_test!
      end

      response '404', 'transaction not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
