module SeedData
  module LargeProjects
    def self.create(user)
      return unless ENV['LARGE_PROJECTS'].present?

      puts "\nCreating 100 large projects with 200 tasks each..."
      100.times do |project_num|
        big_project_name = "Large Project #{project_num + 1}"
        big_project = user.projects.find_or_create_by!(name: big_project_name)
        print '.'

        200.times do |i|
          big_project.tasks.find_or_create_by!(name: "Task #{i + 1}", user: user, done: (i > 20))
        end
      end
      puts "\nCreated 100 large projects"
    end
  end
end
