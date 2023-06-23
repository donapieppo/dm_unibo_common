Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"
  get "/show_if_current_organization", to: "home#show_if_current_organization"
  root to: "home#index"
end
