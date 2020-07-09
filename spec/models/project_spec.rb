require 'rails_helper'

RSpec.describe Project, type: :model do

  it "is valid with a owner and name" do
    expect(FactoryBot.build(:project)).to be_valid
  end

  it "is invalid without name" do
    project = FactoryBot.build(:project, name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # it "does not allow duplicate project names per user" do
  #   user = FactoryBot.create(:user)
  #   FactoryBot.create(:project, name: "Test Project", owner: user)
  #   new_project = FactoryBot.build(:project, name: "Test Project", owner: user)
  #   new_project.valid?
  #   expect(new_project.errors[:name]).to include("has already been taken")
  # end
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  it "allows two users to share a project name" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: "Test Project", owner: user)
    
    other_user = FactoryBot.create(:user)
    other_project = FactoryBot.build(:project, name: "Test Project", owner: other_user)
    expect(other_project).to be_valid 
  end

  describe "late status" do
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end

    it "can have many notes" do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
  end
end
