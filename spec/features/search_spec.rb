# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Search', type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
  end

  scenario 'marks a task as done from search results', :js do
    task = create(:task, project: project, user: user, name: "Searchable task")

    visit search_path(query: "Searchable")

    expect(page).to have_content("Searchable task")

    checkbox = find("#checkbox_task_#{task.id}")
    checkbox.click

    expect(checkbox).to be_checked
    expect(task.reload.done).to be(true)
  end
end
