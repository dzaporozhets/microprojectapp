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

  describe '#due_date_options' do
    context 'when no existing due date is provided' do
      it 'returns predefined options with "No Due Date" at the top' do
        options = helper.due_date_options

        expect(options).to include(['No Due Date', nil])
        expect(options).to include(['Tomorrow', 1.day.from_now.to_date])
        expect(options).to include(['Next Week', 1.week.from_now.to_date])
        expect(options).to include(['Next Month', 1.month.from_now.to_date])
        expect(options).to include(['Next Year', 1.year.from_now.to_date])
      end
    end

    context 'when an existing due date is provided' do
      let(:existing_due_date) { Date.new(2024, 7, 24) }

      it 'includes the existing due date formatted as a human-readable date' do
        options = helper.due_date_options(existing_due_date)

        human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
        expect(options).to include([human_readable_date, existing_due_date])
      end

      it 'places the existing due date at the top of the options list' do
        options = helper.due_date_options(existing_due_date)

        human_readable_date = I18n.l(existing_due_date.to_date, format: :long)
        expect(options.first).to eq([human_readable_date, existing_due_date])
      end

      it 'includes all predefined options' do
        options = helper.due_date_options(existing_due_date)

        expect(options).to include(['No Due Date', nil])
        expect(options).to include(['Tomorrow', 1.day.from_now.to_date])
        expect(options).to include(['Next Week', 1.week.from_now.to_date])
        expect(options).to include(['Next Month', 1.month.from_now.to_date])
        expect(options).to include(['Next Year', 1.year.from_now.to_date])
      end
    end
  end
end
