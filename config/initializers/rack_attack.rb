class Rack::Attack
  # Throttle POST requests to sensitive endpoints by IP address
  throttle('req/ip', limit: 10, period: 60.seconds) do |req|
    if req.post? && req.path == '/users/sign_in'
      req.ip
    end
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Throttle limit reached. Try again later.' }.to_json]]
  end
end
