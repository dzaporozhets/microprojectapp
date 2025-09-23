require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  describe 'PATCH #update' do
    context 'when archiving a project' do
      it 'removes the project from favourites' do
        # Pin the project first
        create(:pin, project: project, user: user)
        expect(project.pins.count).to eq(1)

        # Archive the project
        patch :update, params: { id: project.id, project: { archived: true } }

        # Verify project is archived and pins are removed
        project.reload
        expect(project.archived).to be true
        expect(project.pins.count).to eq(0)
      end

      it 'removes pins from all users who had pinned the project' do
        user2 = create(:user)
        
        # Multiple users pin the project
        create(:pin, project: project, user: user)
        create(:pin, project: project, user: user2)
        expect(project.pins.count).to eq(2)

        # Archive the project
        patch :update, params: { id: project.id, project: { archived: true } }

        # Verify all pins are removed
        project.reload
        expect(project.archived).to be true
        expect(project.pins.count).to eq(0)
      end
    end

    context 'when unarchiving a project' do
      it 'does not affect pins' do
        project.update(archived: true)

        # Unarchive the project
        patch :update, params: { id: project.id, project: { archived: false } }

        project.reload
        expect(project.archived).to be false
        # No pins should be created when unarchiving
        expect(project.pins.count).to eq(0)
      end
    end
  end
end