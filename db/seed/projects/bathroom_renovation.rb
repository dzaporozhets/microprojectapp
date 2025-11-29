module SeedData
  module BathroomRenovation
    def self.create(user)
      project = user.projects.find_or_create_by!(name: "Bathroom Renovation")
      print '.'

      # Create tasks
      tasks = [
        "Get contractor quotes", "Choose tile design for walls and floor", "Select vanity and sink",
        "Pick out bathtub or shower unit", "Choose faucets and fixtures", "Remove old fixtures and tiles",
        "Fix any water damage to walls", "Install new plumbing", "Lay new tile flooring",
        "Install wall tiles and waterproofing", "Mount new vanity and sink", "Install bathtub/shower",
        "Connect all plumbing fixtures", "Install new lighting", "Paint walls and ceiling",
        "Install ventilation fan", "Add mirror and accessories", "Install towel racks and toilet paper holder",
        "Seal grout and caulk joints", "Final cleanup and inspection"
      ]

      tasks.each do |task_name|
        project.tasks.find_or_create_by!(name: task_name, user: user, star: [true, false, false].sample, done: [true, false].sample)
        print '.'
      end

      puts "Created 'Bathroom Renovation' project"
      project
    end
  end
end
