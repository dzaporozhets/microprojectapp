module SeedData
  module Archived
    def self.create(user)
      puts "Creating archived projects..."

      # Archived project 1: Holiday Planning
      holiday_project = user.projects.find_or_create_by!(name: "Holiday Planning 2024", archived: true)
      holiday_tasks = [
        "Buy gifts for family members",
        "Send holiday cards",
        "Book holiday travel tickets",
        "Plan Christmas dinner menu",
        "Decorate the house",
        "Organize gift wrapping station",
        "Buy ingredients for holiday baking",
        "Schedule time off work",
        "Prepare guest room for visitors",
        "Make New Year's Eve plans"
      ]

      holiday_tasks.each do |task_name|
        holiday_project.tasks.find_or_create_by!(name: task_name, user: user, done: true)
        print '.'
      end
      puts "Created archived '#{holiday_project.name}' project"

      # Archived project 2: Home Office Setup
      home_office_project = user.projects.find_or_create_by!(name: "Home Office Setup", archived: true)
      home_office_tasks = [
        "Measure office space dimensions",
        "Research ergonomic desk chairs",
        "Purchase standing desk",
        "Order desk chair and accessories",
        "Install cable management system",
        "Set up monitor arms",
        "Organize desk drawers",
        "Install shelving units",
        "Set up proper lighting",
        "Arrange decorative items",
        "Test webcam and microphone setup",
        "Configure dual monitor setup"
      ]

      home_office_tasks.each do |task_name|
        home_office_project.tasks.find_or_create_by!(name: task_name, user: user, done: true)
        print '.'
      end
      puts "Created archived '#{home_office_project.name}' project"

      # Archive existing projects
      ["Car Maintenance", "Birthday Party Planning", "Learn Spanish"].each do |project_name|
        project = user.projects.find_by(name: project_name)
        if project
          project.update!(archived: true)
          project.tasks.update_all(done: true)
          puts "Archived '#{project_name}' project"
          print '.'
        end
      end
    end

    def self.create_initial_projects(user)
      puts "Creating projects to be archived..."

      # Car Maintenance
      car_project = user.projects.find_or_create_by!(name: "Car Maintenance")
      car_tasks = [
        "Schedule oil change appointment",
        "Replace windshield wipers",
        "Check tire pressure and tread",
        "Get brake pads inspected",
        "Replace cabin air filter",
        "Top up windshield washer fluid",
        "Rotate tires"
      ]

      car_tasks.each do |task_name|
        car_project.tasks.find_or_create_by!(name: task_name, user: user, star: [true, false, false].sample, done: [true, false].sample)
        print '.'
      end

      # Birthday Party Planning
      birthday_project = user.projects.find_or_create_by!(name: "Birthday Party Planning")
      birthday_tasks = [
        "Create guest list",
        "Send invitations",
        "Book venue",
        "Order birthday cake",
        "Plan menu and catering",
        "Buy decorations",
        "Arrange entertainment or DJ",
        "Purchase party favors",
        "Confirm RSVPs"
      ]

      birthday_tasks.each do |task_name|
        birthday_project.tasks.find_or_create_by!(name: task_name, user: user, star: [true, false, false].sample, done: [true, false].sample)
        print '.'
      end

      # Learn Spanish
      spanish_project = user.projects.find_or_create_by!(name: "Learn Spanish")
      spanish_tasks = [
        "Download language learning app",
        "Complete beginner course",
        "Practice 30 minutes daily",
        "Watch Spanish TV shows with subtitles",
        "Find a language exchange partner"
      ]

      spanish_tasks.each do |task_name|
        spanish_project.tasks.find_or_create_by!(name: task_name, user: user, star: [true, false, false].sample, done: [true, false].sample)
        print '.'
      end

      puts "Created initial projects"
    end
  end
end
