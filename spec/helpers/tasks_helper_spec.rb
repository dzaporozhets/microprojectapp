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
end
