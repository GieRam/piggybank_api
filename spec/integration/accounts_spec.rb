# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Accounts API' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.auth_token}" }

  path '/accounts/field/validation' do
    post 'Validate field' do
      tags 'Accounts'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :validation, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
      }

      let!(:account) { create(:account) }

      response '204', 'valid field' do
        let(:validation) { { name: 'Not Taken' } }

        run_test!
      end

      response '400', 'invalid field' do
        schema type: :object, properties: {
          error_message: { type: :string },
        }

        let(:validation) { { name: 'Account Name' } }

        run_test! do |response|
          expect(JSON.parse(response.body)['error_message']).to eq('Name is taken')
        end
      end
    end
  end
end