# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectImportService do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe '#import!' do
    context 'when comments have a different user_email' do
      let(:data) do
        {
          'tasks' => [
            {
              'name' => 'Test task',
              'comments' => [
                { 'body' => 'A comment', 'user_email' => 'other@example.com' }
              ]
            }
          ]
        }
      end

      it 'attributes the comment to the current user' do
        service = described_class.new(project, data, user)
        service.import!

        comment = Comment.last
        expect(comment.user).to eq(user)
      end

      it 'appends the original author email to the comment body' do
        service = described_class.new(project, data, user)
        service.import!

        comment = Comment.last
        expect(comment.body).to include('A comment')
        expect(comment.body).to include('— originally by other@example.com')
      end
    end

    context 'when comments have the current user email' do
      let(:data) do
        {
          'tasks' => [
            {
              'name' => 'Test task',
              'comments' => [
                { 'body' => 'My comment', 'user_email' => user.email }
              ]
            }
          ]
        }
      end

      it 'does not append original author to the body' do
        service = described_class.new(project, data, user)
        service.import!

        comment = Comment.last
        expect(comment.body).to eq('My comment')
      end
    end

    context 'when comments have no user_email' do
      let(:data) do
        {
          'tasks' => [
            {
              'name' => 'Test task',
              'comments' => [
                { 'body' => 'Anonymous comment' }
              ]
            }
          ]
        }
      end

      it 'attributes the comment to the current user' do
        service = described_class.new(project, data, user)
        service.import!

        comment = Comment.last
        expect(comment.user).to eq(user)
      end

      it 'does not append original author to the body' do
        service = described_class.new(project, data, user)
        service.import!

        comment = Comment.last
        expect(comment.body).to eq('Anonymous comment')
      end
    end

    context 'when importing notes' do
      let(:data) do
        {
          'tasks' => [],
          'notes' => [
            { 'title' => 'A note', 'content' => 'Note body', 'user_email' => 'other@example.com' }
          ]
        }
      end

      it 'creates the note in the project' do
        service = described_class.new(project, data, user)
        service.import!

        expect(project.notes.count).to eq(1)
        note = project.notes.last
        expect(note.title).to eq('A note')
        expect(note.user).to eq(user)
      end

      it 'appends original author when user_email differs' do
        service = described_class.new(project, data, user)
        service.import!

        note = project.notes.last
        expect(note.content).to include('Note body')
        expect(note.content).to include('— originally by other@example.com')
      end

      it 'tracks the imported note count' do
        service = described_class.new(project, data, user)
        service.import!

        expect(service.imported_note_count).to eq(1)
        expect(service.import_stats[:note_count]).to eq(1)
      end
    end

    context 'when notes have the current user email' do
      let(:data) do
        {
          'tasks' => [],
          'notes' => [
            { 'title' => 'My note', 'content' => 'My content', 'user_email' => user.email }
          ]
        }
      end

      it 'does not append original author to the content' do
        service = described_class.new(project, data, user)
        service.import!

        note = project.notes.last
        expect(note.content).to eq('My content')
      end
    end

    context 'when data has no notes key' do
      let(:data) { { 'tasks' => [] } }

      it 'imports zero notes' do
        service = described_class.new(project, data, user)
        service.import!

        expect(service.imported_note_count).to eq(0)
      end
    end
  end
end
