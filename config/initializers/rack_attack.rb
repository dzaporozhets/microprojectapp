class Rack::Attack
  # Throttle POST requests to sensitive endpoints by IP address
  throttle('req/ip', limit: 10, period: 60.seconds) do |req|
    if req.post? && %w[/users/sign_in /users/password /users/confirmation].include?(req.path)
      req.ip
    end
  end

  # Throttle POST requests to /users/password by email to prevent mass password reset attempts
  throttle('password_reset/email', limit: 10, period: 600.seconds) do |req|
    req.params['user']['email'].presence if req.path == '/users/password' && req.post?
  end

  # Throttle POST requests to /users/confirmation by email to prevent mass confirmation attempts
  throttle('confirmation/email', limit: 10, period: 600.seconds) do |req|
    req.params['user']['email'].presence if req.path == '/users/confirmation' && req.post?
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Throttle limit reached. Try again later.' }.to_json]]
  end
end
