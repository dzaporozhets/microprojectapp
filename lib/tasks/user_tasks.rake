namespace :user do
  desc "Make a user an admin. Usage: rake user:make_admin EMAIL=user@example.com"
  task make_admin: :environment do
    email = ENV['EMAIL']

    if email.blank?
      puts "Please provide an email address. Usage: rake user:make_admin EMAIL=user@example.com"
      next
    end

    user = User.find_by(email: email)

    if user.nil?
      puts "User with email #{email} not found."
    else
      user.update(admin: true)
      puts "User with email #{email} is now an admin."
    end
  end
end
