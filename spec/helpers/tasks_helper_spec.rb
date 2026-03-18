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

  describe '#collapse_task_path' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    before do
      allow(helper).to receive(:request).and_return(double('request', referer: referer))
    end

    context 'when referer is nil' do
      let(:referer) { nil }

      it 'returns project_path' do
        expect(helper.collapse_task_path(project)).to eq(project_path(project))
      end
    end

    context 'when referer is invalid' do
      let(:referer) { ':::not-a-url' }

      it 'returns project_path' do
        expect(helper.collapse_task_path(project)).to eq(project_path(project))
      end
    end

    context 'when referer ends with project_tasks_path' do
      let(:referer) { "http://test.host#{project_tasks_path(project)}" }

      it 'returns project_tasks_path' do
        expect(helper.collapse_task_path(project)).to eq(project_tasks_path(project))
      end
    end

    context 'when referer ends with completed_project_tasks_path' do
      let(:referer) { "http://test.host#{completed_project_tasks_path(project)}" }

      it 'returns completed_project_tasks_path' do
        expect(helper.collapse_task_path(project)).to eq(completed_project_tasks_path(project))
      end
    end

    context 'when referer ends with project_path' do
      let(:referer) { "http://test.host#{project_path(project)}" }

      it 'returns project_path' do
        expect(helper.collapse_task_path(project)).to eq(project_path(project))
      end
    end

    context 'when referer ends with /tasks' do
      let(:referer) { "http://test.host/tasks" }

      it 'returns tasks_path' do
        expect(helper.collapse_task_path(project)).to eq(tasks_path)
      end
    end

    context 'when referer ends with /activity' do
      let(:referer) { "http://test.host#{project_activity_path(project)}" }

      it 'returns project_activity_path' do
        expect(helper.collapse_task_path(project)).to eq(project_activity_path(project))
      end
    end

    context 'when referer is an unrecognized path' do
      let(:referer) { "http://test.host/some/other/path" }

      it 'returns project_path as default' do
        expect(helper.collapse_task_path(project)).to eq(project_path(project))
      end
    end
  end
end
