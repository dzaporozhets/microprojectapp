module SeedData
  module MobileApp
    def self.create(owner, invited_user)
      # Create a project for the second user and invite the first user
      project = owner.projects.find_or_create_by!(name: "Mobile App Development")

      tasks = [
        { name: "Research React Native vs Flutter", done: true, assigned_to: owner },
        { name: "Set up development environment", done: true, assigned_to: owner },
        { name: "Create app wireframes", done: false, due_date: 4.days.from_now.to_date, assigned_to: invited_user },
        { name: "Implement authentication flow", done: false, due_date: 1.week.from_now.to_date, assigned_to: owner },
        { name: "Build user profile screen", done: false, due_date: 10.days.from_now.to_date, assigned_to: owner },
        { name: "Design app icon and splash screen", done: false, assigned_to: invited_user },
        { name: "Test on iOS devices", done: false, star: true, due_date: nil, assigned_to: invited_user },
        { name: "Test on Android devices", done: false, star: true, due_date: nil, assigned_to: owner },
        { name: "Submit to App Store", done: false, due_date: nil }
      ]

      tasks.each do |task_data|
        assigned_user = if task_data[:assigned_to] == owner
                          owner
                        elsif task_data[:assigned_to] == invited_user
                          invited_user
                        else
                          nil
                        end

        project.tasks.find_or_create_by!(
          name: task_data[:name],
          user: owner,
          done: task_data[:done],
          star: task_data[:star] || false,
          due_date: task_data[:due_date],
          assigned_user: assigned_user
        )
        print '.'
      end

      # Add first user as collaborator
      ProjectUser.find_or_create_by!(project: project, user: invited_user)
      puts "Created 'Mobile App Development' for #{owner.email} and invited #{invited_user.email}"
      print '.'

      # Add comments
      wireframes_task = project.tasks.find_by(name: "Create app wireframes")
      if wireframes_task
        wireframes_task.comments.find_or_create_by!(
          body: "Can you create wireframes for the main screens? Focus on: Login, Home, Profile, Settings",
          user: owner
        )
        wireframes_task.comments.find_or_create_by!(
          body: "Sure! I'll use Figma and share the link once done. Should match the website design system?",
          user: invited_user
        )
        wireframes_task.comments.find_or_create_by!(
          body: "Yes, keep it consistent with the website colors and fonts we're using.",
          user: owner
        )
        print '.'
      end

      auth_task = project.tasks.find_by(name: "Implement authentication flow")
      if auth_task
        auth_task.comments.find_or_create_by!(
          body: "Planning to use Firebase Auth for this. Supports Google and Apple sign-in out of the box.",
          user: owner
        )
        print '.'
      end

      # Add links
      links = [
        { title: "React Native Documentation", url: "https://reactnative.dev/" },
        { title: "Expo Documentation", url: "https://docs.expo.dev/" },
        { title: "Firebase Auth Guide", url: "https://firebase.google.com/docs/auth" },
        { title: "App Store Guidelines", url: "https://developer.apple.com/app-store/review/guidelines/" },
        { title: "Google Play Console", url: "https://play.google.com/console/" }
      ]

      links.each do |link_data|
        project.links.find_or_create_by!(title: link_data[:title], url: link_data[:url], user: owner)
        print '.'
      end

      # Add notes
      seed_files_path = Rails.root.join('db', 'seed', 'files')
      note = project.notes.find_or_create_by!(title: "Project requirements") do |n|
        n.content = "Full requirements document attached."
        n.user = owner
      end

      file_path = seed_files_path.join("project_requirements.txt")
      unless note.attachment.attached?
        note.attachment.attach(
          io: File.open(file_path),
          filename: "project_requirements.txt",
          content_type: 'text/plain'
        )
      end
      print '.'
      puts "Created notes"

      project
    end
  end
end
