# frozen_string_literal: true

require 'swagger_helper'

describe 'Password resets API' do
  path '/password_resets' do
    post 'Create password reset' do
      tags 'Password reset'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :email, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
        }
      }

      response '200', 'created' do
        let(:user) { create(:user, :active) }
        let(:email) { { email: user.email } }
        let(:mailer_spy) { spy('mailer') }

        before do
          allow(UserMailer).to receive(:password_reset).and_return(mailer_spy)
        end

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('username', 'email')
          expect(user.reload.reset_digest).to be_truthy
          expect(user.reset_sent_at.to_s).to eq(Time.zone.now.to_s)
          expect(mailer_spy).to have_received(:deliver_now)
        end
      end

      response '400', 'bad request' do
        let(:email) { { email: 'missing@mail.com' } }

        run_test! do |response|
          expect(JSON.parse(response.body)['error_message'])
            .to eq("User by email: #{email[:email]} not found")
        end
      end
    end
  end

  path '/password_resets/{id}' do
    patch 'Update password' do
      tags 'Password reset'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user_password, in: :body, schema: {
        type: :object,
        properties: {
          password: { type: :string },
          password_confirmation: { type: :string },
        },
      }
      parameter name: :email, in: :query, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'updated' do
        let(:user) { create(:user, :with_password_reset, :active) }
        let(:id) { user.reset_token }
        let(:user_password) { { password: 'New123!', password_confirmation: 'New123!' } }
        let(:email) { user.email }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('access_token', 'refresh_token')
          expect(user.reload.reset_digest).to eq(nil)
        end
      end

      response '401', 'unauthorized' do
        let!(:user) { create(:user, :with_password_reset) }
        let(:id) { user.reset_token }
        let(:user_password) { { password: 'New123!', password_confirmation: 'New123!' } }
        let(:email) { user.email }

        run_test!
      end

      response '400', 'invalid password' do
        let!(:user) { create(:user, :with_password_reset, :active) }
        let(:id) { user.reset_token }
        let(:user_password) { { password: 'wrong', password_confirmation: 'wrong' } }
        let(:email) { user.email }

        run_test! do |response|
          expect(JSON.parse(response.body)).to include('error_message' => 'Validation error')
        end
      end
    end
  end
end
