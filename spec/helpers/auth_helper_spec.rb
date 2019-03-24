# frozen_string_literal: true

class AuthHelperTest
  include AuthHelper

  attr_reader :token

  def initialize(token)
    @token = token
  end

  def request
    @request ||= Request.new(token)
  end

  def render(*args)
    args
  end
end

class Request
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def headers
    {
      'Authorization' => "bearer #{token}"
    }
  end
end

RSpec.describe AuthHelper, type: :helper do
  describe '#login' do
    let(:user) { double(auth_token: 'auth_token', set_refresh_token: 'refresh_token') }
    subject { AuthHelperTest.new(nil).login(user) }

    it { is_expected.to eq(access_token: 'auth_token', refresh_token: 'refresh_token') }
  end

  describe '#authenticate_request' do
    let(:user) { create(:user) }

    context 'authenticates with token' do
      subject { AuthHelperTest.new(user.auth_token).authenticate_request }

      it { is_expected.to eq(nil) }
    end

    context 'unauthorized without token' do
      subject { AuthHelperTest.new(nil).authenticate_request }

      it do
        is_expected.to eq([{ json: { error_message: 'Missing token' },
                             status: :unauthorized }])
      end
    end
  end

  describe '#render_unauthorized' do
    subject { AuthHelperTest.new(nil).render_unauthorized('Unauthorized message') }

    it do
      is_expected.to eq([{ json: { error_message: 'Unauthorized message' },
                           status: :unauthorized }])
    end
  end
end
