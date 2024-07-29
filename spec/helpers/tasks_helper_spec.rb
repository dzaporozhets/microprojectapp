require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe '#calc_textarea_rows' do
    it 'returns default rows when text is blank' do
      expect(helper.calc_textarea_rows('')).to eq(4)
    end

    it 'returns the greater value between the number of lines and the default rows' do
      text = "Line 1\nLine 2\nLine 3"
      expect(helper.calc_textarea_rows(text)).to eq(5)
    end

    it 'returns default rows when the calculated rows are less than default' do
      text = "Line 1"
      expect(helper.calc_textarea_rows(text)).to eq(4)
    end
  end

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
