Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do 
    get "logins/logout" => 'devise/sessions#destroy', :as => :logout
  end

  get "who_impersonate"    => 'impersonations#who_impersonate',    :as => :who_impersonate
  get "impersonate/:id"    => 'impersonations#impersonate',        :as => :impersonate
  get "stop_impersonating" => 'impersonations#stop_impersonating', :as => :stop_impersonating

  get 'helps/index'      => 'helps#index',      :as => :helps
  get "logins/no_access" => 'logins#no_access', :as => :no_access
end


