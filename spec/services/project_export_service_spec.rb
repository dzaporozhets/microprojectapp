# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectExportService do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe '#export_data' do
    it 'includes the project name' do
      data = described_class.new(project).export_data

      expect(data[:project_name]).to eq(project.name)
    end

    it 'returns an empty tasks array when project has no tasks' do
      data = described_class.new(project).export_data

      expect(data[:tasks]).to eq([])
    end

    context 'with tasks' do
      let!(:task) { create(:task, project: project, user: user, name: 'Export me', description: 'Details') }

      it 'includes task attributes' do
        data = described_class.new(project).export_data

        exported_task = data[:tasks].first
        expect(exported_task['name']).to eq('Export me')
        expect(exported_task['description']).to eq('Details')
      end

      it 'includes an empty comments array when task has no comments' do
        data = described_class.new(project).export_data

        expect(data[:tasks].first['comments']).to eq([])
      end

      context 'with comments' do
        let!(:comment) { create(:comment, task: task, user: user, body: 'A comment') }

        it 'includes comment body and user email' do
          data = described_class.new(project).export_data

          exported_comment = data[:tasks].first['comments'].first
          expect(exported_comment['body']).to eq('A comment')
          expect(exported_comment['user_email']).to eq(user.email)
        end
      end
    end

    context 'with multiple tasks' do
      let!(:task_a) { create(:task, project: project, user: user, name: 'First') }
      let!(:task_b) { create(:task, project: project, user: user, name: 'Second') }

      it 'orders tasks by id' do
        data = described_class.new(project).export_data

        names = data[:tasks].map { |t| t['name'] }
        expect(names).to eq(%w[First Second])
      end
    end
  end

  describe '#filename' do
    it 'includes the project id' do
      filename = described_class.new(project).filename

      expect(filename).to include("project-#{project.id}")
    end

    it 'is a json file' do
      filename = described_class.new(project).filename

      expect(filename).to end_with('.json')
    end
  end
end
