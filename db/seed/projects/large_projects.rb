module SeedData
  module LargeProjects
    def self.create(user)
      create_many_projects(user)
      create_large_projects(user)
    end

    def self.create_many_projects(user)
      return unless ENV['MANY_PROJECTS'].present?

      puts "\nCreating 20 projects (10 active, 10 archived)..."
      20.times do |project_num|
        project_name = "Project #{project_num + 1}"
        archived = project_num >= 10
        project = user.projects.find_or_create_by!(name: project_name) do |p|
          p.archived = archived
        end
        project.update!(archived: archived)

        rand(3..10).times do |i|
          project.tasks.find_or_create_by!(name: "Task #{i + 1}", user: user, done: archived || rand < 0.3)
        end
        print '.'
      end
      puts "\nCreated 20 projects (10 active, 10 archived)"
    end

    def self.create_large_projects(user)
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
