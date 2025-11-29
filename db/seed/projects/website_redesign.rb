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
        { name: "Implement contact form", done: false, due_date: 2.weeks.from_now.to_date, assigned_to: :user2 }
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
        { name: "Optimize images for web", done: false, due_date: 2.weeks.from_now.to_date, assigned_to: :user2 },
        { name: "Deploy to staging server", done: false, due_date: 18.days.from_now.to_date, assigned_to: :user2 },
        { name: "Final review and launch", done: false, star: true, due_date: 3.weeks.from_now.to_date, assigned_to: :user1 }
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

      # Add notes
      notes = [
        {
          title: "Design Notes",
          user: user1,
          content: "**Color Palette:**\n- Primary: #2563eb (blue)\n- Secondary: #10b981 (green)\n- Accent: #f59e0b (orange)\n\n**Fonts:**\n- Headings: Inter Bold\n- Body: Inter Regular"
        },
        {
          title: "Technical Stack",
          user: user2,
          content: "**Frontend:**\n- React 18.2\n- Tailwind CSS 3.4\n- Vite for build tooling\n\n**Backend:**\n- Node.js + Express\n- PostgreSQL database\n\n**Hosting:**\n- Vercel (frontend)\n- Railway (backend)\n\n**Domain:**\n- Currently: staging.example.com\n- Production: www.example.com"
        },
        {
          title: "Responsive Breakpoints",
          user: user1,
          content: "Mobile: 320px - 767px\nTablet: 768px - 1023px\nDesktop: 1024px+\nWide: 1440px+\n\nPriority: Mobile-first approach\nAll designs must work perfectly on iPhone SE (375px) and up."
        },
        {
          title: "Performance Goals",
          user: user2,
          content: "**Target Metrics:**\n- First Contentful Paint: < 1.5s\n- Largest Contentful Paint: < 2.5s\n- Time to Interactive: < 3.5s\n- Lighthouse Score: 90+\n\n**Optimizations:**\n- Image lazy loading\n- Code splitting\n- CDN for static assets\n- Compress all images (WebP format)"
        },
        {
          title: "Browser Support",
          user: user1,
          content: "**Required:**\n- Chrome (last 2 versions)\n- Firefox (last 2 versions)\n- Safari (last 2 versions)\n- Edge (last 2 versions)\n\n**Mobile:**\n- iOS Safari 14+\n- Chrome Mobile (latest)\n\n**NOT Supporting:**\n- Internet Explorer (any version)\n- Opera Mini"
        },
        {
          title: "Content Strategy",
          user: user1,
          content: "**Homepage:**\n- Hero section with main value proposition\n- 3 key features showcased\n- Client testimonials carousel\n- Call-to-action for demo\n\n**About Page:**\n- Company story timeline\n- Team photos and bios\n- Mission and values\n\n**Contact:**\n- Form with validation\n- Office location map\n- Social media links"
        },
        {
          title: "Deployment Checklist",
          user: user2,
          content: "**Pre-Launch:**\n- [ ] All pages tested on real devices\n- [ ] Forms tested with validation\n- [ ] SEO meta tags added\n- [ ] Google Analytics installed\n- [ ] SSL certificate configured\n- [ ] 404 page designed\n- [ ] Backup strategy in place\n\n**Post-Launch:**\n- [ ] Monitor error logs first 24h\n- [ ] Check analytics tracking\n- [ ] Submit sitemap to Google\n- [ ] Set up uptime monitoring"
        },
        {
          title: "API Endpoints",
          user: user2,
          content: "**Public:**\n- GET /api/content - Fetch page content\n- POST /api/contact - Submit contact form\n- GET /api/blog - List blog posts\n\n**Authentication:**\n- POST /api/auth/login\n- POST /api/auth/logout\n- GET /api/auth/me\n\n**Admin:**\n- POST /api/admin/content - Update content\n- GET /api/admin/analytics - View stats\n\nBase URL (staging): https://api-staging.example.com\nBase URL (prod): https://api.example.com"
        }
      ]

      notes.each do |note_data|
        project.notes.find_or_create_by!(
          title: note_data[:title],
          user: note_data[:user]
        ) do |note|
          note.content = note_data[:content]
        end
        print '.'
      end

      # Add links
      links = [
        { title: "Figma - Design Tool", url: "https://www.figma.com/" },
        { title: "Tailwind CSS Documentation", url: "https://tailwindcss.com/docs" },
        { title: "Web Design Inspiration - Dribbble", url: "https://dribbble.com/tags/web-design" },
        { title: "React Documentation", url: "https://react.dev/" },
        { title: "Vite Build Tool", url: "https://vitejs.dev/" },
        { title: "Vercel Deployment Guide", url: "https://vercel.com/docs" },
        { title: "Google Lighthouse - Performance Testing", url: "https://developers.google.com/web/tools/lighthouse" },
        { title: "WebPageTest - Speed Analysis", url: "https://www.webpagetest.org/" },
        { title: "Staging Environment", url: "https://staging.example.com" }
      ]

      links.each do |link_data|
        project.links.find_or_create_by!(title: link_data[:title], url: link_data[:url], user: user1)
        print '.'
      end

      # Add files
      seed_files_path = Rails.root.join('db', 'seed', 'files')
      files = ["design_brief.txt", "sitemap.txt"]

      files.each do |filename|
        file_path = seed_files_path.join(filename)
        if File.exist?(file_path)
          project.project_files = project.project_files + [File.open(file_path)]
          project.save!
          print '.'
        end
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

      # Pin Website Redesign project as favorite for user1
      Pin.find_or_create_by!(user: user1, project: project)
      puts "Pinned Website Redesign project as favorite"
      print '.'

      project
    end
  end
end
