require "rails_helper"

RSpec.describe DmUniboCommon::UsersController, type: :controller do
  routes { DmUniboCommon::Engine.routes }

  let(:cesia_user) { create(:user, upn: "pietro.donatini@unibo.it") }
  let(:regular_user) { create(:user, upn: "regular.user@unibo.it") }

  describe "GET #index" do
    it "allows a CESIA user" do
      request.session[:user_id] = cesia_user.id

      get :index

      expect(response).to have_http_status(:ok)
    end

    it "rejects a non-CESIA user" do
      request.session[:user_id] = regular_user.id

      expect { get :index }.to raise_error(DmUniboCommon::NoAccess)
    end

    it "redirects an unauthenticated user to the host application's home page" do
      get :index

      expect(response).to redirect_to(Rails.application.routes.url_helpers.home_path)
    end
  end

  describe "POST #create" do
    it "synchronizes a user when requested by a CESIA user" do
      request.session[:user_id] = cesia_user.id
      allow(::User).to receive(:syncronize).with("new.user@unibo.it")

      post :create, params: {upn: "new.user@unibo.it"}

      expect(::User).to have_received(:syncronize).with("new.user@unibo.it")
      expect(response).to redirect_to(DmUniboCommon::Engine.routes.url_helpers.users_path)
    end
  end
end
