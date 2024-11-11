DmUniboCommon::Engine.routes.draw do
  get "auth/shibboleth/callback", to: "logins#shibboleth"
  get "auth/azure_activedirectory_v2/callback", to: "logins#azure_activedirectory_v2"

  # get "auth/google_oauth2/callback", to: "logins#google_oauth2"

  if Rails.env.development? && Rails.configuration.unibo_common.omniauth_provider == :developer
    get "auth/developer/callback", to: "logins#developer"
  end
  if Rails.env.test?
    get "auth/test/callback", to: "logins#test"
  end

  get "logins/logout", to: "logins#logout", as: :logout
  get "logins/no_access", to: "logins#no_access", as: :no_access
  get "logins/pippo_show", to: "logins#pippo_show"

  get "who_impersonate", to: "impersonations#who_impersonate", as: :who_impersonate
  get "impersonate/:id", to: "impersonations#impersonate", as: :impersonate
  get "stop_impersonating", to: "impersonations#stop_impersonating", as: :stop_impersonating

  # in App model User with include DmUniboCommon::User
  resources :users
  # in App model Organization with include DmUniboCommon::Organization
  resources :organizations
  # in app/models/dm_unibo_common
  resources :permissions

  resources :organizations do
    resources :permissions
  end

  # example: with https://example.it/math your working on
  # Organization.find_by_code('math')
  # restart app after adding new organization
  # Organization.find_each do |o|
  #   get o.code, to: "home#index", __org__: o.code
  # end

  get "helps/index", to: "helps#index", as: :helps

  # remember !!!!
  # scope ":__org__" do
  #   get '/', to: 'home#index', as: 'current_organization_root'
end
