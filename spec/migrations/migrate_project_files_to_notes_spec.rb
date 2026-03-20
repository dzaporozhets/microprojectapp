require 'rails_helper'
require_relative '../../db/migrate/20260319194832_migrate_project_files_to_notes'

RSpec.describe MigrateProjectFilesToNotes, type: :migration do
  let(:migration) { described_class.new }
  let(:user) { create(:user) }

  context "when project_files column does not exist" do
    it "does nothing" do
      create(:project, user: user)

      expect { migration.up }.not_to change { Note.count }
    end
  end

  context "when project_files column exists" do
    before do
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Base.connection.add_column :projects, :project_files, :json unless ActiveRecord::Base.connection.column_exists?(:projects, :project_files)
      end
      # Clear prepared statement cache after schema change
      ActiveRecord::Base.connection.clear_cache!
    end

    after do
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Base.connection.remove_column :projects, :project_files if ActiveRecord::Base.connection.column_exists?(:projects, :project_files)
      end
      ActiveRecord::Base.connection.clear_cache!
    end

    it "creates a note for a project with files" do
      project = create(:project, user: user)
      ActiveRecord::Base.connection.execute(
        "UPDATE projects SET project_files = '[\"report.pdf\", \"notes.txt\"]' WHERE id = #{project.id}"
      )

      expect { migration.up }.to change { Note.count }.by(1)

      note = Note.last
      expect(note.project_id).to eq(project.id)
      expect(note.user_id).to eq(user.id)
      expect(note.title).to eq("Files")
      expect(note.content).to include("report.pdf")
      expect(note.content).to include("notes.txt")
      expect(note.content).to include("/projects/#{project.id}/files/download?file=report.pdf")
    end

    it "skips projects with no files" do
      project = create(:project, user: user)
      ActiveRecord::Base.connection.execute(
        "UPDATE projects SET project_files = '[]' WHERE id = #{project.id}"
      )

      expect { migration.up }.not_to change { Note.count }
    end

    it "skips projects with null project_files" do
      create(:project, user: user)

      expect { migration.up }.not_to change { Note.count }
    end
  end
end
