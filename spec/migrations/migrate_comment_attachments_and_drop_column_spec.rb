require 'rails_helper'
require_relative '../../db/migrate/20260320063707_migrate_comment_attachments_and_drop_column'

RSpec.describe MigrateCommentAttachmentsAndDropColumn, type: :migration do
  let(:migration) { described_class.new }
  let(:user) { create(:user) }

  context "when attachment column does not exist" do
    it "does nothing" do
      expect { migration.up }.not_to change { Note.count }
    end
  end

  context "when attachment column exists" do
    before do
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Base.connection.add_column :comments, :attachment, :string unless ActiveRecord::Base.connection.column_exists?(:comments, :attachment)
      end
      ActiveRecord::Base.connection.clear_cache!
    end

    after do
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Base.connection.remove_column :comments, :attachment if ActiveRecord::Base.connection.column_exists?(:comments, :attachment)
      end
      ActiveRecord::Base.connection.clear_cache!
    end

    it "creates a note per project for comments with attachments" do
      project = create(:project, user: user)
      task = create(:task, project: project, user: user)
      comment = create(:comment, task: task, user: user)
      ActiveRecord::Base.connection.execute(
        "UPDATE comments SET attachment = 'report.pdf' WHERE id = #{comment.id}"
      )

      expect { migration.up }.to change { Note.count }.by(1)

      note = Note.last
      expect(note.project_id).to eq(project.id)
      expect(note.title).to eq("Comment attachments")
      expect(note.content).to include("report.pdf")
    end

    it "groups attachments from same project into one note" do
      project = create(:project, user: user)
      task = create(:task, project: project, user: user)
      c1 = create(:comment, task: task, user: user)
      c2 = create(:comment, task: task, user: user)
      ActiveRecord::Base.connection.execute(
        "UPDATE comments SET attachment = 'file1.pdf' WHERE id = #{c1.id}"
      )
      ActiveRecord::Base.connection.execute(
        "UPDATE comments SET attachment = 'file2.pdf' WHERE id = #{c2.id}"
      )

      expect { migration.up }.to change { Note.count }.by(1)

      note = Note.last
      expect(note.content).to include("file1.pdf")
      expect(note.content).to include("file2.pdf")
    end

    it "skips comments without attachments" do
      project = create(:project, user: user)
      task = create(:task, project: project, user: user)
      create(:comment, task: task, user: user)

      expect { migration.up }.not_to change { Note.count }
    end

    it "removes the attachment column" do
      migration.up

      expect(ActiveRecord::Base.connection.column_exists?(:comments, :attachment)).to be false
    end
  end
end
