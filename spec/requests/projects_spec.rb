require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "as an authenticated user" do
    before do
      @user = FactoryBot.create(:user)
    end

    it "responds successfully when get projects_path" do
      sign_in @user
      get projects_path
      expect(response).to be_success
    end

    context "with valid attributes" do
      it "adds a project" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params}
        }.to change(@user.projects, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not add a project" do
        project_params = FactoryBot.attributes_for(:project, :invalid)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params}
        }.to_not change(@user.projects, :count)
      end
    end
  end
end
