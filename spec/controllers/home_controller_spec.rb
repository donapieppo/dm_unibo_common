require "rails_helper"

RSpec.describe HomeController, type: :controller do
  render_views

  let(:current_user) { FactoryBot.create(:user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  it "correct response for index" do
    request.session[:user_id] = current_user.id
    get :index
    expect(response.body).to match(/<h1>Hello test/)
  end

  it "show_if_current_organization raises without current_organization" do
    request.session[:user_id] = current_user.id
    expect { get :show_if_current_organization }.to raise_error(Pundit::NotAuthorizedError)
  end

  it "show_if_current_organization raises with wrong organization" do
    request.session[:user_id] = current_user.id
    FactoryBot.create(:permission, user: current_user, organization: org1, authlevel: 1)
    expect { get :show_if_current_organization, params: {__org__: org2.code} }.to raise_error(Pundit::NotAuthorizedError)
  end

  it "show_if_current_organization redirects to index with wrong organization" do
    request.session[:user_id] = current_user.id
    FactoryBot.create(:permission, user: current_user, organization: org1, authlevel: 1)
    get :show_if_current_organization, params: {__org__: org1.code}
    expect(response.body).to match(/hidden content/)
  end
end
