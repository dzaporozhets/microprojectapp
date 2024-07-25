if ENV['DEV_DATA'].present?
  user = User.first
  puts "Creating sample projects for #{user.email}"

  projects_with_tasks = {
    "Home Renovation" => [
      "Paint living room", "Install new kitchen cabinets", "Upgrade bathroom fixtures", "Refinish hardwood floors",
      "Replace windows", "Install new light fixtures", "Renovate basement", "Landscape the front yard",
      "Install a new roof", "Add insulation to attic and walls", "Upgrade electrical system to modern standards",
      "Replace plumbing fixtures throughout the house", "Install smart home devices for better control",
      "Redesign interior layout for open concept", "Upgrade to energy-efficient appliances in kitchen and laundry",
      "Install a home security system with cameras", "Renovate attic into livable space", "Build a deck in the backyard",
      "Install solar panels on the roof", "Replace garage door with an automatic opener"
    ],
    "Personal Finance Management" => [
      "Create monthly budget", "Review investment portfolio", "Track expenses", "Set up emergency fund for unexpected events",
      "Plan for retirement by assessing 401k and IRA options", "Review credit report for inaccuracies", "Pay off high-interest debt",
      "Automate bill payments to avoid late fees", "Create savings plan for big purchases", "Set financial goals for the next year",
      "Review insurance policies to ensure adequate coverage", "Invest in stocks and mutual funds",
      "Start a side business to generate extra income", "Review mortgage options for better rates",
      "Plan for large purchases like a car or home", "Create a will and estate plan", "Set up a trust fund for children",
      "Meet with financial advisor for expert advice", "Plan for child's education expenses", "Review tax strategy for potential savings"
    ],
    "Vacation Planning" => [
      "Research destinations", "Book flights", "Reserve accommodation", "Plan daily itinerary with sightseeing spots",
      "Pack luggage with essentials and travel documents", "Arrange transportation to and from airport",
      "Buy travel insurance for the entire trip", "Prepare travel documents and copies", "Book tours and activities in advance",
      "Learn local phrases for easier communication", "Exchange currency before departure", "Research local cuisine and restaurants",
      "Plan for emergencies with a contact list", "Make restaurant reservations ahead of time", "Check weather forecast and pack accordingly",
      "Notify bank of travel plans to avoid card issues", "Arrange pet care during absence", "Prepare home for long absence",
      "Set up travel budget and track expenses", "Confirm travel arrangements and bookings"
    ],
    "Fitness and Health Goals" => [
      "Create workout plan", "Schedule gym sessions", "Track daily calorie intake using an app", "Buy workout gear and equipment",
      "Join a fitness class for motivation", "Set fitness goals for strength and endurance", "Track progress with weekly measurements",
      "Plan healthy meals and snacks", "Consult with a nutritionist for diet advice", "Stay hydrated throughout the day",
      "Get adequate sleep for muscle recovery", "Warm up before exercise to prevent injuries", "Cool down after exercise with stretches",
      "Monitor heart rate during workouts", "Incorporate strength training exercises", "Practice yoga for flexibility and stress relief",
      "Take rest days to prevent overtraining", "Avoid injuries by using proper form", "Stay motivated with a fitness journal",
      "Evaluate progress and adjust goals regularly"
    ],
    "Gardening Projects" => [
      "Plant vegetable garden", "Install irrigation system", "Prune trees and bushes", "Build a compost bin for garden waste",
      "Plant flower beds with seasonal blooms", "Install garden lighting along pathways", "Create a garden path with stepping stones",
      "Build raised garden beds for easier access", "Install a garden pond with fish and plants", "Grow herb garden for fresh seasonings",
      "Build a greenhouse for year-round gardening", "Install a rainwater collection system", "Plant a fruit orchard with various trees",
      "Mulch garden beds to retain moisture", "Install garden fencing to keep pests out", "Attract pollinators with specific plants",
      "Control garden pests with organic methods", "Start a garden journal to track progress", "Plan garden layout for optimal growth",
      "Join a gardening club for tips and advice"
    ]
  }

  projects_with_tasks.each do |project_name, tasks|
    project = Project.find_or_create_by!(name: project_name, user: user)
    print '.'

    tasks.each do |task_name|
      project.tasks.find_or_create_by!(name: task_name, user: user)
      print '.'
    end
  end

  project = user.projects.find_by!(name: "Personal Finance Management")
  task = project.tasks.find_by!(name: "Plan for large purchases like a car or home")

  # Comments to be added
  comments = [
    "Have you considered setting a specific savings goal for the down payment? It might be helpful to create a separate savings account to track progress more easily.",
    "Don't forget to research different financing options. Comparing interest rates from various lenders could save a significant amount of money over time.",
    "It’s important to factor in long-term costs such as maintenance, insurance, and property taxes. Have you included these in your budget plan?",
    "Improving your credit score can significantly impact the interest rates you qualify for. Have you checked your current score and considered steps to improve it before making a purchase?",
    "Conducting a market analysis can be crucial. For example, understanding current housing market trends or car depreciation rates can help make a more informed decision."
  ]

  # Add comments to the task
  comments.each do |comment_text|
    task.comments.find_or_create_by!(body: comment_text, user: user)
    print '.'
  end

  # Generate one big project with 100+ tasks
  big_project_name = "Very large project"
  big_project = Project.find_or_create_by!(name: big_project_name, user: user)
  print '.'

  200.times do |i|
    big_project.tasks.find_or_create_by!(name: "Task #{i + 1}", user: user, done: (i > 20))
  end
end
