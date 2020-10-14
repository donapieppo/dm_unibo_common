class Authorization
  include DmUniboCommon::Authorization

  _authlevels = { 
    read:   1, 
    manage: 2, 
    pippo: 3
  }

  configure_authlevels(_authlevels)
  DmUniboCommon::OrganizationPolicy.configure_authlevels(_authlevels)

end

