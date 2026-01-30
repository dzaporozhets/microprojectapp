require 'rails_helper'

RSpec.describe 'Rack::Attack with Devise', type: :request do
  let(:throttled_ip) { '1.2.3.4' }
  let(:user_email) { 'user@example.com' }

  before do
    # Use in-memory cache for testing purposes
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  context 'when rate limit is exceeded for IP' do
    it 'throttles excessive requests to /users/sign_in' do
      Rack::Attack.cache.store.write("rack::attack:#{throttled_ip}:req/ip", 10)

      10.times do
        post user_session_path, params: { user: { email: user_email, password: 'password' } }, headers: { 'REMOTE_ADDR' => throttled_ip }
      end

      # The 11th request should be throttled
      post user_session_path, params: { user: { email: user_email, password: 'password' } }, headers: { 'REMOTE_ADDR' => throttled_ip }

      expect(response.status).to eq(429) # 429 Too Many Requests
      expect(response.body).to include('Throttle limit reached. Try again later.')
    end
  end
end
