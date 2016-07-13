Rails.application.routes.draw do
  get 'auth/google_oauth2/callback', to: 'logins#google_oauth2'
  get 'auth/shibboleth/callback',    to: 'logins#shibboleth'
  get 'auth/developer/callback',    to: 'logins#developer'
  get 'logins/logout',               to: 'logins#logout',   as: :logout
  get 'logins/no_access',            to: 'logins#no_access', as: :no_access

  get 'who_impersonate',         to: 'impersonations#who_impersonate',    as: :who_impersonate
  get 'impersonate/:id',         to: 'impersonations#impersonate',        as: :impersonate
  get 'stop_impersonating',      to: 'impersonations#stop_impersonating', as: :stop_impersonating

  get 'helps/index',             to: 'helps#index',      as: :helps
end


