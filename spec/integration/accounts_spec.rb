# frozen_string_literal: true

require 'swagger_helper'
require_relative './swagger_schemas'

def account_properties
  {
    id: { type: :integer },
    name: { type: :string },
    description: { type: :string },
  }
end

def account_request
  {
    name: { type: :string },
    description: { type: :string },
  }
end

RSpec.describe 'Accounts API' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.auth_token}" }

  path '/accounts' do
    get 'List accounts' do
      tags 'Accounts'
      produces 'application/json'

      response '200', 'list accounts' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: account_properties,
               }

        let(:account) { create(:account) }
        before { account.users << user }

        run_test! do |response|
          expect(JSON.parse(response.body).length).to eq(1)
          expect(JSON.parse(response.body)[0]['name']).to eq(account.name)
        end
      end
    end

    post 'Create account' do
      tags 'Accounts'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :account, in: :body, type: :object,
                properties: account_request

      response '201', 'created' do
        let(:account) do
          {
            name: 'AccountName',
            description: 'Test Description'
          }
        end

        run_test! do |response|
          expect(JSON.parse(response.body)).to include(
            'name' => account[:name],
            'description' => account[:description]
          )
        end
      end

      response '400', 'validation errors' do
        schema SwaggerSchemas.validation_errors

        let(:account) { { name: 'T' } }

        run_test!
      end
    end
  end

  path '/accounts/{id}' do
    get 'Show account' do
      tags 'Accounts'
      produces 'applciation/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'show account' do
        let(:account) { create(:account) }
        let(:id) { account.id }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('id', 'name', 'description')
        end
      end

      response '404', 'not found' do
        let(:id) { 99 }

        run_test!
      end
    end

    patch 'Update account' do
      tags 'Accounts'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :account, in: :body, type: :object,
                properties: account_request
      parameter name: :id, in: :path, type: :integer

      response '202', 'account updated' do
        schema type: :object,
               properties: account_properties

        let(:account) do
          {
            name: 'AccountName',
            description: 'Testing Description',
          }
        end

        let(:id) { create(:account).id }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('id','name', 'description')
        end
      end

      response '400', 'validation errors' do
        schema SwaggerSchemas.validation_errors
        let(:account) { { name: 'T' } }
        let(:id) { create(:account).id }

        run_test!
      end
    end

    delete 'Delete account' do
      tags 'Accounts'
      parameter name: :id, in: :path, type: :integer

      response '204', 'account deleted' do
        let(:id) { create(:account).id }

        run_test! do
          expect(Account.count).to eq(0)
        end
      end
    end
  end

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