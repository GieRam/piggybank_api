# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('PiggyBank account activation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@piggybank.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

  describe 'password_reset' do
    let(:user) { create(:user, :with_password_reset) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('PiggyBank password reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@piggybank.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('To reset your password click the link below')
    end
  end
end
