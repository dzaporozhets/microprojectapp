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
    project = Project.create!(name: project_name, user: user)
    project.create_sample_tasks
  end
end

if ENV['DEV_DATA_BIG'].present? && Rails.env.development?
  require 'factory_bot_rails'

  # All objects will be created for one user
  user = User.first

  puts "Creating a lot of data for #{user.email}"

  project = Project.find_by(name: 'Large Project')

  unless project && project.tasks.count > 500
    project ||= FactoryBot.create(:project, name: 'Large Project', user: user)

    5.times { project.users << FactoryBot.create(:user) }

    99.times do |i|
      FactoryBot.create(:task, name: "task-open-#{i}", project: project, user: project.users.sample)
    end

    900.times do |i|
      FactoryBot.create(:task, name: "task-done-#{i}", project: project, user: project.users.sample, done: true)
    end

    puts '* 1 large project created'
  end

  50.times do |i|
    project = FactoryBot.create(:project, name: "Small Project #{i}", user: user)
    project.create_sample_tasks
    project.create_sample_links
  end

  puts '* 50 small projects created'
end
