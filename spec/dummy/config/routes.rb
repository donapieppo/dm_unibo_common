Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common", :as => "dm_unibo_common"

  get "/logins/logout", to: "dm_unibo_common/logins#logout"

  get "/show_if_current_organization", to: "home#show_if_current_organization"
  get "/home", to: "home#index", as: "home"
  root to: "home#index"
end
