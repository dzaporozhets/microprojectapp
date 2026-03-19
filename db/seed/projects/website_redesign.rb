module SeedData
  module WebsiteRedesign
    def self.create(user1, user2)
      # Create collaborative "Website Redesign" project
      project = user1.projects.find_or_create_by!(name: "Website Redesign")
      print '.'

      # Add second user as collaborator
      ProjectUser.find_or_create_by!(project: project, user: user2)
      puts "Created collaborative 'Website Redesign' project"
      print '.'

      # Tasks created by first user (designer)
      tasks_user1 = [
        { name: "Research competitor websites", done: true, assigned_to: :user1 },
        { name: "Create wireframes for new design", done: true, assigned_to: :user1 },
        { name: "Design mockups in Figma", done: false, due_date: 3.days.from_now.to_date, assigned_to: :user1 },
        { name: "Get stakeholder approval on design", done: false, due_date: 1.week.from_now.to_date, assigned_to: :user1 },
        { name: "Create homepage layout", done: false, star: true, due_date: 10.days.from_now.to_date, assigned_to: :user2 },
        { name: "Implement contact form", done: false, due_date: nil, assigned_to: :user2 }
      ]

      tasks_user1.each do |task_data|
        assigned_user = task_data[:assigned_to] == :user1 ? user1 : user2
        project.tasks.find_or_create_by!(
          name: task_data[:name],
          user: user1,
          done: task_data[:done],
          star: task_data[:star] || false,
          due_date: task_data[:due_date],
          assigned_user: assigned_user
        )
        print '.'
      end

      # Tasks created by second user (developer)
      tasks_user2 = [
        { name: "Set up development environment", done: true, assigned_to: :user2 },
        { name: "Build responsive navbar", done: true, assigned_to: :user2 },
        { name: "Add image gallery component", done: false, due_date: 5.days.from_now.to_date, assigned_to: :user2 },
        { name: "Test on mobile devices", done: false, star: true, due_date: 12.days.from_now.to_date, assigned_to: :user1 },
        { name: "Optimize images for web", done: false, due_date: nil, assigned_to: :user2 },
        { name: "Deploy to staging server", done: false, due_date: nil, assigned_to: :user2 },
        { name: "Final review and launch", done: false, star: true, due_date: 2.months.from_now.to_date, assigned_to: :user1 }
      ]

      tasks_user2.each do |task_data|
        assigned_user = task_data[:assigned_to] == :user1 ? user1 : user2
        project.tasks.find_or_create_by!(
          name: task_data[:name],
          user: user2,
          done: task_data[:done],
          star: task_data[:star] || false,
          due_date: task_data[:due_date],
          assigned_user: assigned_user
        )
        print '.'
      end

      # Add comments from both users to design task
      design_task = project.tasks.find_by(name: "Design mockups in Figma")
      if design_task
        design_task.comments.find_or_create_by!(
          body: "I've started on the homepage mockup. Using the color palette from our design brief - blue primary with green accents.",
          user: user1
        )
        design_task.comments.find_or_create_by!(
          body: "Looks great! Can you make sure the mobile breakpoint is at 768px? That'll make implementation easier.",
          user: user2
        )
        design_task.comments.find_or_create_by!(
          body: "Good point! I'll adjust the responsive breakpoints accordingly. Also adding tablet view.",
          user: user1
        )
        print '.'
      end

      # Add comments from both users to navbar task
      navbar_task = project.tasks.find_by(name: "Build responsive navbar")
      if navbar_task
        navbar_task.comments.find_or_create_by!(
          body: "Navbar is done! Used Tailwind CSS with a hamburger menu for mobile. Check the staging link.",
          user: user2
        )
        navbar_task.comments.find_or_create_by!(
          body: "Perfect! The animations are smooth. Just one thing - can we make the logo a bit larger on desktop?",
          user: user1
        )
        navbar_task.comments.find_or_create_by!(
          body: "Sure, I'll increase it by 20%. Should be updated in 5 mins.",
          user: user2
        )
        print '.'
      end

      # Add comments to gallery task
      gallery_task = project.tasks.find_by(name: "Add image gallery component")
      if gallery_task
        gallery_task.comments.find_or_create_by!(
          body: "Should we use a lightbox library or build a custom one? I'm thinking react-image-gallery might be good.",
          user: user2
        )
        gallery_task.comments.find_or_create_by!(
          body: "react-image-gallery looks good. Make sure it supports lazy loading for the images!",
          user: user1
        )
        print '.'
      end

      # Add comments to homepage layout task
      homepage_task = project.tasks.find_by(name: "Create homepage layout")
      if homepage_task
        homepage_task.comments.find_or_create_by!(
          body: "Working on the hero section first. Should we use a video background or static image?",
          user: user1
        )
        homepage_task.comments.find_or_create_by!(
          body: "Static image for now - better for performance. We can add video later if needed.",
          user: user2
        )
        homepage_task.comments.find_or_create_by!(
          body: "Good point! I'll use a high-quality static image with a subtle gradient overlay.",
          user: user1
        )
        print '.'
      end

      # Add comments to mobile testing task
      mobile_task = project.tasks.find_by(name: "Test on mobile devices")
      if mobile_task
        mobile_task.comments.find_or_create_by!(
          body: "Priority devices to test:\n- iPhone 13/14 (Safari)\n- Samsung Galaxy S22 (Chrome)\n- iPad Pro (Safari)\n- Pixel 6 (Chrome)",
          user: user2
        )
        print '.'
      end

      # Add comments to deployment task
      deploy_task = project.tasks.find_by(name: "Deploy to staging server")
      if deploy_task
        deploy_task.comments.find_or_create_by!(
          body: "Reminder: Update env variables on Vercel before deploying. API keys need to be configured.",
          user: user2
        )
        deploy_task.comments.find_or_create_by!(
          body: "Also double-check the domain DNS settings are pointing correctly to staging subdomain.",
          user: user1
        )
        print '.'
      end

      # Add activities to populate activity tab
      puts "Creating activity history..."

      # Activities for tasks created by first user
      research_task = project.tasks.find_by(name: "Research competitor websites")
      project.add_activity(user1, 'created', research_task) if research_task
      project.add_activity(user1, 'closed', research_task) if research_task

      wireframes_task = project.tasks.find_by(name: "Create wireframes for new design")
      project.add_activity(user1, 'created', wireframes_task) if wireframes_task
      project.add_activity(user1, 'closed', wireframes_task) if wireframes_task

      mockups_task = project.tasks.find_by(name: "Design mockups in Figma")
      project.add_activity(user1, 'created', mockups_task) if mockups_task

      approval_task = project.tasks.find_by(name: "Get stakeholder approval on design")
      project.add_activity(user1, 'created', approval_task) if approval_task

      homepage_task = project.tasks.find_by(name: "Create homepage layout")
      project.add_activity(user1, 'created', homepage_task) if homepage_task

      contact_task = project.tasks.find_by(name: "Implement contact form")
      project.add_activity(user1, 'created', contact_task) if contact_task

      # Activities for tasks created by second user
      dev_env_task = project.tasks.find_by(name: "Set up development environment")
      project.add_activity(user2, 'created', dev_env_task) if dev_env_task
      project.add_activity(user2, 'closed', dev_env_task) if dev_env_task

      navbar_build_task = project.tasks.find_by(name: "Build responsive navbar")
      project.add_activity(user2, 'created', navbar_build_task) if navbar_build_task
      project.add_activity(user2, 'closed', navbar_build_task) if navbar_build_task

      gallery_task = project.tasks.find_by(name: "Add image gallery component")
      project.add_activity(user2, 'created', gallery_task) if gallery_task

      mobile_test_task = project.tasks.find_by(name: "Test on mobile devices")
      project.add_activity(user2, 'created', mobile_test_task) if mobile_test_task

      optimize_task = project.tasks.find_by(name: "Optimize images for web")
      project.add_activity(user2, 'created', optimize_task) if optimize_task

      staging_task = project.tasks.find_by(name: "Deploy to staging server")
      project.add_activity(user2, 'created', staging_task) if staging_task

      launch_task = project.tasks.find_by(name: "Final review and launch")
      project.add_activity(user2, 'created', launch_task) if launch_task

      # Activities for comments
      project.add_activity(user1, 'commented on', mockups_task) if mockups_task
      project.add_activity(user2, 'commented on', mockups_task) if mockups_task
      project.add_activity(user2, 'commented on', navbar_build_task) if navbar_build_task
      project.add_activity(user1, 'commented on', navbar_build_task) if navbar_build_task

      print '.'
      puts "Activity history created"

      # Add notes
      notes = [
        { title: "Brand guidelines", content: "Primary color: #2563EB (blue-600)\nSecondary: #10B981 (green-500)\nFont: Inter for headings, System UI for body\nBorder radius: 8px for cards, 4px for buttons\nMax content width: 1280px", user: user1, attachment: "design_brief.txt" },
        { title: "Meeting notes - Kickoff", content: "Attendees: design team, stakeholders\n\nKey decisions:\n- Target launch date: end of Q2\n- Mobile-first approach\n- Keep existing blog content, redesign layout\n- New hero section with product demo video\n- Reduce page load time to under 2 seconds", user: user1 },
        { title: "SEO requirements", content: "- Maintain existing URL structure to preserve rankings\n- Add structured data (JSON-LD) for all pages\n- Ensure all images have alt text\n- Target Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1\n- Create XML sitemap and submit to Search Console", user: user2, attachment: "sitemap.txt" },
        { title: "Accessibility checklist", content: "WCAG 2.1 AA compliance required:\n- Color contrast ratio minimum 4.5:1\n- All interactive elements keyboard accessible\n- ARIA labels on icons and buttons\n- Skip navigation link\n- Form labels and error messages\n- Tested with screen reader (VoiceOver + NVDA)", user: user2 },
        { title: "Performance budget", content: "Page weight targets:\n- HTML: < 50KB\n- CSS: < 80KB\n- JS: < 200KB\n- Images: < 500KB per page (use WebP)\n- Total: < 1MB first load\n\nTools: Lighthouse CI in pipeline, WebPageTest for baseline", user: user2 }
      ]

      seed_files_path = Rails.root.join('db', 'seed', 'files')

      notes.each do |note_data|
        note = project.notes.find_or_create_by!(title: note_data[:title]) do |n|
          n.content = note_data[:content]
          n.user = note_data[:user]
        end

        if note_data[:attachment]
          file_path = seed_files_path.join(note_data[:attachment])
          unless note.attachment.attached?
            note.attachment.attach(
              io: File.open(file_path),
              filename: note_data[:attachment],
              content_type: 'text/plain'
            )
          end
        end

        print '.'
      end
      puts "Created notes"

      # Pin Website Redesign project as favorite for user1
      Pin.find_or_create_by!(user: user1, project: project)
      puts "Pinned Website Redesign project as favorite"
      print '.'

      project
    end
  end
end
