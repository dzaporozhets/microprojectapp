module SeedData
  module Personal
    def self.create(user)
      project = user.projects.find_by(name: "Personal")
      return unless project

      puts "Adding tasks to Personal project..."

      tasks = [
        # Completed tasks (past tasks that are done)
        { name: "Buy groceries for the week", done: true },
        { name: "Schedule dentist appointment", done: true },
        { name: "Renew car registration", done: true },
        { name: "Pay credit card bill", done: true },
        { name: "Call mom for her birthday", done: true },
        { name: "Return Amazon package", done: true },
        { name: "Take car for oil change", done: true },
        { name: "Update resume", done: true },
        { name: "Clean out email inbox", done: true },
        { name: "Organize closet", done: true },
        { name: "Cancel unused subscriptions", done: true },
        { name: "Backup photos from phone", done: true },
        { name: "Replace air filters in house", done: true },
        { name: "Get prescription refilled", done: true },
        { name: "File tax documents", done: true },
        { name: "Water plants", done: true },
        { name: "Pick up dry cleaning", done: true },
        { name: "Reply to Sarah's email", done: true },

        # Active tasks (things to do) with due dates
        { name: "Book flight for summer vacation", done: false, star: true, due_date: 2.weeks.from_now.to_date },
        { name: "Find a new gym", done: false, due_date: 1.week.from_now.to_date },
        { name: "Schedule annual checkup", done: false, star: true, due_date: 3.days.from_now.to_date },
        { name: "Fix leaky bathroom faucet", done: false, due_date: 5.days.from_now.to_date },
        { name: "Research new phone plans", done: false, due_date: 10.days.from_now.to_date },
        { name: "Donate old clothes to charity", done: false },
        { name: "Change smoke detector batteries", done: false }
      ]

      tasks.each do |task_data|
        project.tasks.find_or_create_by!(
          name: task_data[:name],
          user: user,
          done: task_data[:done],
          star: task_data[:star] || false,
          due_date: task_data[:due_date]
        )
        print '.'
      end

      # Add comments to specific tasks
      vacation_task = project.tasks.find_by(name: "Book flight for summer vacation")
      if vacation_task
        vacation_task.comments.find_or_create_by!(
          body: "Looking at flights to Japan for cherry blossom season. Prices are around $1,200 per person on JAL.",
          user: user
        )
        vacation_task.comments.find_or_create_by!(
          body: "Alternative: Iceland in September for Northern Lights. Flights only $600 on Icelandair.",
          user: user
        )
        print '.'
      end

      checkup_task = project.tasks.find_by(name: "Schedule annual checkup")
      if checkup_task
        checkup_task.comments.find_or_create_by!(
          body: "Dr. Smith's office: (555) 123-4567. Need to call Monday morning when they open at 9am.",
          user: user
        )
        print '.'
      end

      faucet_task = project.tasks.find_by(name: "Fix leaky bathroom faucet")
      if faucet_task
        faucet_task.comments.find_or_create_by!(
          body: "It's the hot water side. Might just need a new washer - check YouTube for DIY videos first.",
          user: user
        )
        faucet_task.comments.find_or_create_by!(
          body: "Update: Ordered replacement parts from Amazon ($15). Should arrive Thursday.",
          user: user
        )
        print '.'
      end

      gym_task = project.tasks.find_by(name: "Find a new gym")
      if gym_task
        gym_task.comments.find_or_create_by!(
          body: "Options nearby:\n- LA Fitness: $30/month\n- Planet Fitness: $10/month\n- Equinox: $200/month (probably too expensive)\n- 24 Hour Fitness: $40/month",
          user: user
        )
        print '.'
      end

      puts "Personal project populated with #{tasks.count} tasks"

      # Add notes to personal project
      notes = [
        {
          title: "Vacation Ideas",
          content: "**Destinations to Consider:**\n- Japan (cherry blossom season - April)\n- Iceland (Northern Lights - Sept-March)\n- Portugal (Porto and Lisbon)\n- New Zealand (hiking and nature)\n\n**Budget:** ~$3,000-4,000 per person\n**Duration:** 10-14 days\n\n**Need to decide by:** End of January"
        },
        {
          title: "Home Improvements Wishlist",
          content: "**Priority:**\n1. Fix leaky bathroom faucet (urgent)\n2. Paint bedroom (spring project)\n3. Replace kitchen cabinet handles\n4. Install smart thermostat\n5. Upgrade outdoor lighting\n\n**Long-term:**\n- Renovate guest bathroom\n- Add deck to backyard\n- Replace old windows"
        },
        {
          title: "Books to Read",
          content: "**Currently Reading:**\n- \"Atomic Habits\" by James Clear\n\n**Up Next:**\n- \"Project Hail Mary\" by Andy Weir\n- \"The Psychology of Money\" by Morgan Housel\n- \"Educated\" by Tara Westover\n- \"Shoe Dog\" by Phil Knight\n\n**Genre Mix:** Business/Self-help + Fiction"
        },
        {
          title: "Health & Wellness Goals",
          content: "**Fitness:**\n- Join gym by end of month\n- Work out 3-4x per week\n- Try yoga class\n\n**Medical:**\n- Schedule annual checkup ✓ (need to book)\n- Dentist cleaning every 6 months\n- Eye exam (last one: 2 years ago)\n\n**Diet:**\n- Meal prep Sundays\n- Cut back on coffee (max 2 cups/day)\n- Drink more water (8 glasses/day goal)"
        },
        {
          title: "Gift Ideas",
          content: "**Mom's Birthday (March 15):**\n- Spa day gift certificate\n- Photo album of family memories\n- Kitchen gadget she mentioned\n\n**Dad's Birthday (July 8):**\n- Golf accessories\n- Book about history\n- BBQ tools set\n\n**Sarah's Wedding (June):**\n- From registry + personal card\n- Budget: $150-200"
        },
        {
          title: "Monthly Budget Notes",
          content: "**Fixed Expenses:**\n- Rent: $1,800\n- Car payment: $350\n- Insurance: $180\n- Phone: $70\n- Utilities: ~$150\n- Subscriptions: $45 (Netflix, Spotify, etc.)\n\n**Variable:**\n- Groceries: $400-500\n- Gas: $120\n- Entertainment: $200\n- Dining out: $150\n\n**Savings Goal:** $800/month"
        },
        {
          title: "Phone & Internet Plans",
          content: "**Current Plan:**\n- Provider: Verizon\n- Cost: $70/month\n- Data: Unlimited\n\n**Alternatives to Research:**\n- T-Mobile: $60/month (unlimited)\n- Mint Mobile: $30/month (35GB)\n- Google Fi: $50/month (flexible)\n\n**Internet:**\n- Current: Xfinity $65/month (400 Mbps)\n- Could switch to AT&T Fiber ($55 for 500 Mbps)\n\n**Potential Savings:** $20-40/month"
        }
      ]

      notes.each do |note_data|
        project.notes.find_or_create_by!(
          title: note_data[:title],
          user: user
        ) do |note|
          note.content = note_data[:content]
        end
        print '.'
      end

      puts "Added #{notes.count} notes to Personal project"

      # Add useful links to personal project
      links = [
        { title: "Vacation Booking - Expedia", url: "https://www.expedia.com/" },
        { title: "Gym Finder - ClassPass", url: "https://classpass.com/" },
        { title: "Book Reviews - Goodreads", url: "https://www.goodreads.com/" },
        { title: "Budget Tracker - Mint", url: "https://mint.intuit.com/" },
        { title: "Phone Plan Comparison", url: "https://www.whistleout.com/CellPhones" },
        { title: "Home Improvement Ideas - Houzz", url: "https://www.houzz.com/" }
      ]

      links.each do |link_data|
        project.links.find_or_create_by!(title: link_data[:title], url: link_data[:url], user: user)
        print '.'
      end

      puts "Added #{links.count} links to Personal project"

      # Pin Personal project as favorite
      Pin.find_or_create_by!(user: user, project: project)
      puts "Pinned Personal project as favorite"
      print '.'

      project
    end
  end
end
