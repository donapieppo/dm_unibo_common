# see dm_unibo_common/lib/dm_unibo_common/controllers/helpers.rb for
# update_authorization which does
# current_user.extend(DmUniboCommon::CurrentUser) && current_user.update_authorization_by_ip(request.remote_ip)
# in app/controlers/application_controller.rb
# before_action :set_current_user, :update_authorization
module DmUniboCommon::CurrentUser
  def update_authorization_by_ip(ip)
    @_authorization = Authorization.new(ip, self)
  end

  def current_organization=(o)
    @_current_organization = o
  end

  def authorization
    @_authorization
  end

  def current_organization
    @_current_organization
  end

  def has_some_authorization?
    @_authorization&.any?
  end

  def single_organization?
    @_authorization&.single_organization?
  end

  def multi_organizations?
    @_authorization&.multi_organizations?
  end

  def my_organizations(ordering: :name)
    @_authorization ? @_authorization.organizations(ordering: ordering) : []
  end

  def can_read?(oid)
    @_authorization&.can_read?(oid)
  end

  def can_manage?(oid)
    @_authorization&.can_manage?(oid)
  end

  def debug_authorizations
    @_authorization
  end
end
