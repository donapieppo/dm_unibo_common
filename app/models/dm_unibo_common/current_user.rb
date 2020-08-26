module DmUniboCommon::CurrentUser
  def authorization
    @_authorization
  end

  def update_authorization_by_ip(ip)
    @_authorization = DmUniboCommon::Authorization.new(ip, self)
  end

  def has_some_authorization?
    @_authorization && @_authorization.any?
  end

  def my_organizations
    @_authorization ? @_authorization.organizations : []
  end
end
