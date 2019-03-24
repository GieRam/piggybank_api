# frozen_string_literal: true

require 'swagger_helper'
require_relative './swagger_schemas'

RSpec.describe 'Users API' do
  path '/users' do
    post 'Create user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
        },
      }

      response '200', 'created' do
        schema SwaggerSchemas.user

        let(:user) do
          {
            username: 'Test',
            email: 'test@mail.com',
            password: 'Test123!',
            password_confirmation: 'Test123!',
          }
        end

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('username', 'email')
        end
      end

      response '400', 'validation errors' do
        schema SwaggerSchemas.validation_errors

        let(:user) { { username: 'Test' } }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include(
            'error_message' => 'Validation error'
          )
        end
      end
    end
  end

  path '/users/field/validation' do
    post 'Validate field' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :validation, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string },
        },
      }

      let!(:user) { create(:user) }

      response '204', 'valid field' do
        let(:validation) { { email: 'nottaken@mail.com' } }

        run_test!
      end

      response '400', 'invalid field' do
        schema type: :object, properties: {
          error_message: { type: :string },
        }

        let(:validation) { { email: 'test@mail.com' } }

        run_test! do |response|
          expect(JSON.parse(response.body)['error_message']).to eq('Email is taken')
        end
      end
    end
  end
end
