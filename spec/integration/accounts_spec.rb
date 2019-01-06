# frozen_string_literal: true

require 'swagger_helper'

describe 'Accounts API' do

  path '/accounts' do
    post 'Creates an account' do
      tags 'Accounts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          tag_ids: { type: :array, items: { type: :integer } }
        },
        required: ['name']
      }

      response '201', 'account created' do
        let(:account) { { name: 'test account' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:account) { { name: 'a' * 256 } }
        run_test!
      end
    end
  end
end