require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe '#dom_task_comments_id' do
    it 'returns the correct DOM id for task comments' do
      task = double('Task', id: 1)
      expect(helper.dom_task_comments_id(task)).to eq('task_1_comments')
    end
  end

  describe '#dom_task_comment_form_id' do
    it 'returns the correct DOM id for task comment form' do
      task = double('Task', id: 1)
      expect(helper.dom_task_comment_form_id(task)).to eq('task_1_new_comment')
    end
  end

  describe '#tasks_lists_page?' do
    let(:project) { double('Project', id: 1) }

    before do
      allow(helper).to receive(:project_path).with(project).and_return('/projects/1')
      allow(helper).to receive(:project_tasks_path).with(project).and_return('/projects/1/tasks')
      allow(helper).to receive(:completed_project_tasks_path).with(project).and_return('/projects/1/tasks/completed')
      allow(helper).to receive(:current_page?).and_return(false)
    end

    it 'returns true when on the project show page' do
      allow(helper).to receive(:current_page?).with('/projects/1').and_return(true)
      expect(helper.tasks_lists_page?(project)).to be true
    end

    it 'returns true when on the project tasks page' do
      allow(helper).to receive(:current_page?).with('/projects/1/tasks').and_return(true)
      expect(helper.tasks_lists_page?(project)).to be true
    end

    it 'returns true when on the completed tasks page' do
      allow(helper).to receive(:current_page?).with('/projects/1/tasks/completed').and_return(true)
      expect(helper.tasks_lists_page?(project)).to be true
    end

    it 'returns false when on other pages' do
      expect(helper.tasks_lists_page?(project)).to be false
    end
  end
end
