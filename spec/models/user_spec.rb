# frozen_string_literal: true

RSpec.describe User, type: :model do
  let(:now) { Time.zone.now }

  describe '.new_token' do
    subject { described_class.new_token }

    its(:size) { is_expected.to eq(22) }
  end

  describe '.digest' do
    subject { described_class.digest('password') }

    its(:size) { is_expected.to eq(60) }
  end

  describe '#authenticated?' do
    let(:user) { build(:user, :with_password_reset) }
    subject { user.authenticated?(:reset, user.reset_token) }

    it { is_expected.to be_truthy }

    context 'wrong token' do
      subject { user.authenticated?(:reset, 'wrong') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#activate' do
    let(:user) { create(:user) }
    subject { user.activate }

    it 'activates today' do
      Timecop.freeze(now) do
        subject
        expect(user.activated).to be_truthy
        expect(user.activated_at.to_s).to eq(now.to_s)
      end
    end
  end

  describe '#create_reset_digest' do
    let(:user) { create(:user) }
    subject { user.create_reset_digest }

    it 'creates reset digest' do
      Timecop.freeze(now) do
        subject
        expect(user.reset_token.size).to eq(22)
        expect(user.reset_digest.size).to eq(60)
        expect(user.reset_sent_at.to_s).to eq(now.to_s)
      end
    end
  end

  describe '#send_password_reset_email' do
    let(:user) { build(:user) }
    subject { build(:user).send_password_reset_email }

    it 'sends password reset email' do
      mailer = spy('mailer')
      expect(UserMailer).to receive(:password_reset).and_return(mailer)
      expect(mailer).to receive(:deliver_now)
      subject
    end
  end

  describe '#password_reset_expired?' do
    let(:user) { build(:user) }
    subject { user.password_reset_expired? }

    context 'expired' do
      before { user.reset_sent_at = now - 3.hours }

      it { is_expected.to be_truthy }
    end

    context 'valid' do
      before { user.reset_sent_at = now }

      it { is_expected.to be_falsey }
    end
  end

  describe '#auth_token' do
    let(:user) { create(:user) }
    subject { user.auth_token }

    it 'encodes user id' do
      expect(JsonWebToken.decode(subject)['user_id']).to eq(user.id)
    end
  end

  describe '#set_refresh_token' do
    let(:user) { create(:user) }
    subject { user.set_refresh_token }

    it 'sets refresh token' do
      expect(subject.size).to eq(60)
      expect(user.refresh_token).to eq(subject)
    end
  end
end
