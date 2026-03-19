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
        { name: "Find a new gym", done: false, due_date: nil },
        { name: "Schedule annual checkup", done: false, star: true, due_date: 3.days.from_now.to_date },
        { name: "Fix leaky bathroom faucet", done: false, due_date: nil },
        { name: "Research new phone plans", done: false, due_date: nil },
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

      # Pin Personal project as favorite
      Pin.find_or_create_by!(user: user, project: project)
      puts "Pinned Personal project as favorite"
      print '.'

      project
    end
  end
end
