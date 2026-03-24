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

      # Add notes
      project.notes.find_or_create_by!(title: "Contractor contacts") do |n|
        n.content = "Plumber: Mike's Plumbing (555) 234-5678 — recommended by neighbor\nTile installer: ABC Tiles (555) 345-6789 — quoted $2,500 for floor + walls\nElectrician: Spark Electric (555) 456-7890 — available next week"
        n.user = user
      end
      print '.'

      project.notes.find_or_create_by!(title: "Material selections") do |n|
        n.content = "Floor tile: Porcelain 12x24 in Light Gray — $4.50/sqft from Home Depot\nWall tile: Subway 3x6 White Glossy — $2.00/sqft\nVanity: 36\" single sink, walnut finish — $450 from Wayfair\nFaucet: Brushed nickel single-handle — $120\nShowerhead: Rain shower 10\" chrome — $85"
        n.user = user
      end
      print '.'
      puts "Created notes"

      puts "Created 'Bathroom Renovation' project"
      project
    end
  end
end
