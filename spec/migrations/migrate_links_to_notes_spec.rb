require 'rails_helper'
require_relative '../../db/migrate/20260319193844_migrate_links_to_notes'

RSpec.describe MigrateLinksToNotes, type: :migration do
  let(:migration) { described_class.new }
  let(:user) { create(:user) }

  context "when links table does not exist" do
    it "does nothing" do
      create(:project, user: user)

      expect { migration.up }.not_to change { Note.count }
    end
  end

  context "when links table exists" do
    before do
      ActiveRecord::Migration.suppress_messages do
        unless ActiveRecord::Base.connection.table_exists?(:links)
          ActiveRecord::Base.connection.create_table :links do |t|
            t.string :title
            t.string :url, null: false
            t.references :user, null: false, foreign_key: true
            t.references :project, null: false, foreign_key: true
            t.timestamps
          end
        end
      end
    end

    after do
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Base.connection.drop_table :links if ActiveRecord::Base.connection.table_exists?(:links)
      end
    end

    it "creates a note with all links for a project" do
      project = create(:project, user: user)
      ActiveRecord::Base.connection.execute(<<-SQL)
        INSERT INTO links (title, url, user_id, project_id, created_at, updated_at)
        VALUES ('Docs', 'https://example.com/docs', #{user.id}, #{project.id}, NOW(), NOW()),
               (NULL, 'https://example.com/raw', #{user.id}, #{project.id}, NOW(), NOW())
      SQL

      expect { migration.up }.to change { Note.count }.by(1)

      note = Note.last
      expect(note.project_id).to eq(project.id)
      expect(note.user_id).to eq(user.id)
      expect(note.title).to eq("Links")
      expect(note.content).to include("Docs - https://example.com/docs")
      expect(note.content).to include("https://example.com/raw")
      expect(note.content).not_to include("null")
    end

    it "drops the links table" do
      migration.up

      expect(ActiveRecord::Base.connection.table_exists?(:links)).to be false
    end

    it "skips projects with no links" do
      create(:project, user: user)

      expect { migration.up }.not_to change { Note.count }
    end
  end
end
