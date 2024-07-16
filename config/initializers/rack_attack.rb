class Rack::Attack
  # Throttle POST requests to /users/password by IP address
  throttle('req/ip', limit: 5, period: 60.seconds) do |req|
    req.ip if req.path == '/users/password' && req.post?
  end

  # Throttle POST requests to /users/password by email
  throttle('password_reset/email', limit: 5, period: 3600.seconds) do |req|
    req.params['user']['email'].presence if req.path == '/users/password' && req.post?
  end

  self.throttled_responder = lambda do |req|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Throttle limit reached. Try again later.' }.to_json]]
  end
end
