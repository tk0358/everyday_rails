require 'rails_helper'

RSpec.feature "Notes", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:project) {
    FactoryBot.create(:project, 
      name: "RSpec tutorial", 
      owner: user)
  }
  scenario "user adds a note" do
    # user = FactoryBot.create(:user)
    # project = FactoryBot.create(:project, owner: user)
    sign_in user
    visit root_path
    click_link project.name
    click_link "Add Note"
    expect {
      fill_in "Message", with: "Note Test"
      click_button "Create Note"
      expect(page).to have_content "Note was successfully created."
      expect(page).to have_content "Note Test"
    }.to change(project.notes, :count).by(1)
  end

  scenario "user deletes a note", js: true, slow: true do
    # user = FactoryBot.create(:user)
    # project = FactoryBot.create(:project, owner: user)
    note = FactoryBot.create(:note, user: user,project: project)
    sign_in user
    visit root_path
    click_link project.name
    expect(page).to have_content project.name
    expect(page).to have_content note.message
    expect(page).to have_content "Delete"
    execute_script('window.scrollBy(0,10000)')
    p project.notes.count
    expect {
      accept_confirm do
        click_on "Delete"
      end
      expect(page).to have_content "Note was successfully destroyed."
    }.to change(project.notes, :count).by(-1)
  end

  scenario "user uploads an attachment" do
    sign_in user
    visit project_path(project)
    click_link "Add Note"
    fill_in "Message", with: "My book cover"
    attach_file "Attachment", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "Create Note"
    expect(page).to have_content "Note was successfully created"
    expect(page).to have_content "My book cover"
    expect(page).to have_content "attachment.jpg (image/jpeg"
  end
end
