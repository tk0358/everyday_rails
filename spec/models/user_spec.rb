require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a first name, last name, email, and password" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # it "is invalid without a first name" do
  #   user = FactoryBot.build(:user, first_name: nil)
  #   user.valid?
  #   expect(user.errors[:first_name]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :first_name }

  # it "is invalid without a last name" do
  #   user = FactoryBot.build(:user, last_name: nil)
  #   user.valid?
  #   expect(user.errors[:last_name]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :last_name }

  # it "is invalid without an email address" do
  #   user = FactoryBot.build(:user, email: nil)
  #   user.valid?
  #   expect(user.errors[:email]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :email }

  # it "is invalid with a duplicate email address" do
  #   FactoryBot.create(:user, email: "ruru@example.com")
  #   user = FactoryBot.build(:user, email: "ruru@example.com")
  #   user.valid?
  #   expect(user.errors[:email]).to include("has already been taken")
  # end
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  subject(:user) { FactoryBot.build(:user) }
  it { is_expected.to satisfy {|user| user.name == "Aaron Summer" }}
  # it "returns a user's full name as a string" do
  #   user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
  #   expect(user.name).to eq "John Doe"
  # end
end
