require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do
  describe '#project_tabs' do
    let(:project) { create(:project) }

    before do
      assign(:project, project)
      allow(helper).to receive(:project_path).and_return("/projects/#{project.id}")
      allow(helper).to receive(:project_schedule_path).and_return("/projects/#{project.id}/schedule")
    end

    it 'constructs the correct tabs array' do
      expected_tabs = [
        { name: 'Tasks', path: "/projects/#{project.id}" },
        { name: 'Schedule', path: "/projects/#{project.id}/schedule" }
      ]

      expect(helper).to receive(:render_tabs).with(expected_tabs, nil)

      helper.project_tabs
    end

    it 'passes the selected tab to render_tabs' do
      selected_tab = 'Tasks'

      expected_tabs = [
        { name: 'Tasks', path: "/projects/#{project.id}" },
        { name: 'Schedule', path: "/projects/#{project.id}/schedule" }
      ]

      expect(helper).to receive(:render_tabs).with(expected_tabs, selected_tab)

      helper.project_tabs(selected_tab)
    end
  end
end
