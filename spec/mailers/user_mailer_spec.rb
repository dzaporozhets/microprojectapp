require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe '#send_otp' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.send_otp(user) }

    before do
      allow(user).to receive(:current_otp).and_return('123456')
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Your OTP Code for Two-Factor Authentication')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials.dig(:mailer, :default_from) || 'from@example.com'])
    end

    it 'renders the body with the correct OTP code' do
      expect(mail.body.encoded).to include('Your OTP code is: 123456')
    end

    it 'delivers the email to the correct user' do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
