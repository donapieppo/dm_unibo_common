Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"
  root to: "home#index"
end
