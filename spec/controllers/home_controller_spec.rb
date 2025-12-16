require "rails_helper"

RSpec.describe HomeController, type: :controller do
  render_views

  let(:current_user) { FactoryBot.create(:user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  before(:each) do
    request.session[:user_id] = current_user.id
  end

  it "correct response for index" do
    get :index
    expect(response.body).to match(/<h1>Hello test/)
  end

  # in spec/dummy/app/controllers/application_controller.rb
  # before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :redirect_unsigned_user
  it "show_if_current_organization with no current_user redirects_to root" do
    request.session[:user_id] = nil
    get :show_if_current_organization, params: {__org__: org2.code}
    expect(response).to redirect_to(home_path)
  end

  it "show_if_current_organization redirects when current_organization missing" do
    get :show_if_current_organization
    expect(response).to redirect_to(home_path)
    expect(flash[:alert]).to eq("Non siete abilitati ad accedere alla pagina.")
  end

  it "show_if_current_organization redirects when policy missing" do
    get :show_if_current_organization, params: {__org__: org2.code}
    expect(response).to redirect_to(home_path)
    expect(flash[:alert]).to eq("Non siete abilitati ad accedere alla pagina.")
  end

  it "show_if_current_organization redirects with wrong organization" do
    FactoryBot.create(:permission, user: current_user, organization: org1, authlevel: 1)
    get :show_if_current_organization, params: {__org__: org2.code}
    expect(response).to redirect_to(home_path)
    expect(flash[:alert]).to eq("Non siete abilitati ad accedere alla pagina.")
  end

  it "show_if_current_organization ok with correct organization" do
    FactoryBot.create(:permission, user: current_user, organization: org1, authlevel: 1)
    get :show_if_current_organization, params: {__org__: org1.code}
    expect(response.body).to match(/hidden content/)
  end
end
