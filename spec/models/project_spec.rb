require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "password"
    )
  end

  it "is valid with a owner and name" do
    project = Project.new(
      owner: @user,
      name: "Sample Project"
    )
    expect(project).to be_valid
  end

  it "is invalid without name" do
    project = @user.projects.build(
      name: nil
    )
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it "does not allow duplicate project names per user" do

    @user.projects.create(
      name: "Test Project"
    )

    new_project = @user.projects.build(
      name: "Test Project"
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    @user.projects.create(
      name: "Test Project"
    )

    other_user = User.create(
      first_name: "Jane",
      last_name: "Tester",
      email: "janetester@example.com",
      password: "password"
    )

    other_project = other_user.projects.build(
      name: "Test Project"
    )

    expect(other_project).to be_valid 
  end
end
