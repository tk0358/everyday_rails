require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # include LoginSupport
  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, owner: user) }

  scenario "user creates a new project" do
    sign_in user
    go_to_project("New Project")

    expect {
      fill_in_texts
      click_button "Create Project"
      expect_made_project
    }.to change(user.projects, :count).by(1)
  end

  scenario "when guest visit projects_pat, redirect_to sign_in" do
    visit projects_path
    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  scenario "user edit the project" do
    sign_in user
    go_to_project(project.name)
    click_link "Edit"

    fill_in_texts
    click_button "Update Project"
    expect_made_project
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def fill_in_texts
    fill_in "Name", with: "Testing Project"
    fill_in "Description", with: "This is testing"
  end

  def expect_made_project
    aggregate_failures do
      expect(page).to have_content "Project was successfully"
      expect(page).to have_content "Testing Project"
    end
  end
end
