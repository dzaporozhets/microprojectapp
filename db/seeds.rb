if Rails.env.development?
  # Load all project seed modules
  Dir[Rails.root.join('db/seed/projects/*.rb')].each { |file| require file }

  # Create or find the first user
  user = User.find_or_create_by!(email: "dev@localhost") do |u|
    u.password = "dev@localhost"
    u.password_confirmation = "dev@localhost"
    u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
  end
  puts "Creating sample projects for #{user.email}"

  # Create second user
  second_user = User.find_or_create_by!(email: "user2@example.com") do |u|
    u.password = "user2@example.com"
    u.password_confirmation = "user2@example.com"
    u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
  end
  puts "Created second user: #{second_user.email}\n"

  # Create active projects
  SeedData::BathroomRenovation.create(user)
  SeedData::Personal.create(user)
  SeedData::WebsiteRedesign.create(user, second_user)

  # Create projects that will be archived
  SeedData::Archived.create_initial_projects(user)

  # Create second user's project with first user invited
  SeedData::MobileApp.create(second_user, user)

  # Archive completed projects
  SeedData::Archived.create(user)

  # Create large projects if ENV flag is set
  SeedData::LargeProjects.create(user)

  puts "\n✅ Seed data created successfully!"
end
