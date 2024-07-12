# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
#
if ENV['DEV_DATA'].present?
  user = User.create!(
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password'
  )

  # Create sample projects associated with the user
  projects = [
    "Home Renovation",
    "Personal Finance Management",
    "Vacation Planning",
    "Fitness and Health Goals",
    "Gardening Projects",
    "Family Reunion Planning",
    "Learn a New Language",
    "Photography Portfolio",
    "Creative Writing",
    "Meal Planning and Recipes"
  ]

  projects.each do |project_name|
    Project.create!(name: project_name, user: user)
  end
end
