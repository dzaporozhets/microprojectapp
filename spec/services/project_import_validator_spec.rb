# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectImportValidator do
  describe '#valid?' do
    context 'when file is nil' do
      subject { described_class.new(nil, { 'tasks' => [] }) }

      it 'returns false' do
        expect(subject.valid?).to be false
      end

      it 'adds a file presence error' do
        subject.valid?
        expect(subject.errors).to include('Please upload a file.')
      end
    end

    context 'when file exceeds 5MB' do
      let(:file) { double('file', size: 6.megabytes) }

      subject { described_class.new(file, { 'tasks' => [] }) }

      it 'returns false' do
        expect(subject.valid?).to be false
      end

      it 'adds a file size error' do
        subject.valid?
        expect(subject.errors).to include('File size should be less than 5 MB.')
      end
    end

    context 'when data tasks field is not an array' do
      let(:file) { double('file', size: 1.megabyte) }

      subject { described_class.new(file, { 'tasks' => 'not-an-array' }) }

      it 'returns false' do
        expect(subject.valid?).to be false
      end

      it 'adds a JSON structure error' do
        subject.valid?
        expect(subject.errors).to include('Invalid JSON file format: tasks should be an array.')
      end
    end

    context 'when task count exceeds the limit' do
      let(:file) { double('file', size: 1.megabyte) }
      let(:tasks) { Array.new(Task::TASK_LIMIT + 1, {}) }

      subject { described_class.new(file, { 'tasks' => tasks }) }

      it 'returns false' do
        expect(subject.valid?).to be false
      end

      it 'adds a task limit error' do
        subject.valid?
        expect(subject.errors).to include("Too many tasks. Maximum allowed is #{Task::TASK_LIMIT} items.")
      end
    end

    context 'with a valid file and data' do
      let(:file) { double('file', size: 1.megabyte) }

      subject { described_class.new(file, { 'tasks' => [] }) }

      it 'returns true' do
        expect(subject.valid?).to be true
      end

      it 'has no errors' do
        subject.valid?
        expect(subject.errors).to be_empty
      end
    end
  end
end
