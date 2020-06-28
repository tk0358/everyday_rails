require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "can create a user with valid input" do
    visit root_path
    click_link "Sign up"
    expect {
      fill_in "First name", with: "Ruru"
      fill_in "Last name", with: "Kaseda"
      fill_in "Email", with: "ruru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(page).to have_content("Welcome! You have signed up successfully.")
      expect(page).to have_content("Projects")
    }.to change(User, :count).by(1)
  end

  scenario "cannot create a user when password and password confirmation is different" do
    visit root_path
    click_link "Sign up"
    expect {
      fill_in "First name", with: "Ruru"
      fill_in "Last name", with: "Kaseda"
      fill_in "Email", with: "ruru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "another_password"
      click_button "Sign up"

      expect(page).to have_content("1 error prohibited this user from being saved:")
      expect(page).to have_content("Password confirmation doesn't match Password")
    }.to_not change(User, :count)
  end
end
