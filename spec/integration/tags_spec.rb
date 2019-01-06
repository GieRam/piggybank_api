# frozen_string_literal: true

require 'swagger_helper'

describe 'Tags API' do

  path '/tags' do
    get 'Lists tags' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'tags found' do
        schema type: :array,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[id name created_at updated_at]
        let!(:tag) { create(:tag) }
        run_test!
      end
    end

    post 'Creates a tag' do
      tags 'Tags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'tag created' do
        let(:tag) { { name: 'Test Tag' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:tag) { { name: 'Test Tag' } }
        let!(:second_tag) { create(:tag, name: 'Test Tag') }
        run_test!
      end
    end
  end
end