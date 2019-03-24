# frozen_string_literal: true

require 'swagger_helper'
require_relative './swagger_schemas'

describe 'Account activation API' do
  path '/users/activation' do
    get 'Activate user' do
      produces 'application/json'
      parameter name: :email, in: :query, type: :string
      parameter name: :token, in: :query, type: :string

      response '200', 'Logs in user' do
        schema SwaggerSchemas.login

        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:token) { user.activation_token }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('access_token', 'refresh_token')
          expect(user.reload.activated).to eq(true)
        end
      end

      response '401', 'Unauthorized' do
        schema SwaggerSchemas.error

        let(:user) { create(:user) }
        let(:email) { user.email }
        let(:token) { 'invalid' }

        run_test! do
          expect(user.activated).to eq(false)
        end
      end
    end
  end
end
