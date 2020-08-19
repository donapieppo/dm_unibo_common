module DmUniboCommon
  class CurrentUser < ::User
    self.inheritance_column = :_type_disabled
    # DmUniboCommon::Authorization (access levels to organizations)
    attr_reader :authorization 

    def update_authorization_by_ip(ip)
      @authorization = DmUniboCommon::Authorization.new(ip, self)
    end
  end
end
