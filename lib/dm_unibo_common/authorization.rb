# the authlevel is just a list of authlevel on organizations
# and depends from  client ip and login name (upn)

# a = DmUniboCommon::Authorization.new(client_ip, user)
# a.can_read?(Organization.first)
# from ip and user reads the permissions on all organizations
module DmUniboCommon::Authorization
  TO_CESIA = 100

  # @authlevels[46] = DmUniboCommon::Authorization::TO_ADMIN
  # means that "user:ip" can admin organization with id=46
  attr_reader :authlevels

  # @@authlevels_cache[k][46] = DmUniboCommon::Authorization::TO_ADMIN
  # means that key k can admin organization with id=46
  @@authlevels_cache = Hash.new { |h, k| h[k] = {} }

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Authorization depends on client ip and user
  def initialize(client_ip, user)
    @user = user
    @client_ip = client_ip
    @is_cesia = CESIA_UPN.include?(@user.upn)
    @authlevels_cache_key = "#{user.id}:#{client_ip}"

    update_authlevels_cache(@authlevels_cache_key)

    @authlevels = @@authlevels_cache[@authlevels_cache_key] || {}
  end

  def any?
    @authlevels.any?
  end

  # multi_organizations?: false/true if user has access to more than one organization
  def multi_organizations?
    @authlevels && @authlevels.size > 1
  end

  def organizations
    ::Organization.order(:name).find(@authlevels.keys)
  end

  def authlevel(o)
    i = o.is_a?(::Organization) ? o.id : o
    @authlevels[i]
  end

  def first_organization_id
    @authlevels.keys.first
  end

  def organization_authlevel(oid)
    oid = oid.id if oid.is_a?(::Organization)
    @authlevels[oid]
  end

  def is_cesia?
    @is_cesia
  end

  # FIXME !!!!
  def can_manage_an_organization?
    @authlevels.values.select { |n| n >= 40 }.any?
  end

  module ClassMethods
    # example: h = { read: 10, manage: 20 }
    # creates methods like can_read?, can_manage?
    #                      can_only_read?, can_only_manage?
    # use in config/initializers
    def configure_authlevels
      @@authlevels = Rails.configuration.authlevels

      @@authlevels.each do |name, number|
        define_method :"can_#{name}?" do |oid|
          return true if is_cesia?
          a = organization_authlevel(oid)
          a && a >= number
        end

        define_method :"can_only_#{name}?" do |oid|
          a = organization_authlevel(oid)
          a && a == number
        end
      end
    end

    def all_authlevels
      @@authlevels
    end

    # TO_CESIA only by file configuration
    def all_level_list
      @@authlevels.values
    end

    # to clear cache !!!!
    def authlevels_reload!
      @@authlevels_cache = Hash.new { |h, k| h[k] = {} }
    end

    # per visualizzazione livelli di autorizzazione
    def level_description(level, html = 1)
      p = @@authlevels.select { |s, n| n == level }
      I18n.t("can_#{p.keys.first}")
    end
  end

  private

  # uno user puo' essere in diverse organizations con diversi authlevels
  # se si trova nel database admin sovrascrivo authlevel di update_authlevels_by_network
  # user permission overrides network permissions
  # in organization prendiamo quella più alta ordinando
  def update_authlevels_cache(k)
    return @@authlevels_cache[k] if @@authlevels_cache.key?(k)

    each_network do |network|
      DmUniboCommon::Permission.where(network: network).each do |net|
        @@authlevels_cache[k][net.organization_id] = @is_cesia ? TO_CESIA : net.authlevel.to_i
      end
    end

    @user.permissions.order(authlevel: :asc).each do |permission|
      if @is_cesia
        @@authlevels_cache[k][permission.organization_id] = TO_CESIA
      else
        @@authlevels_cache[k][permission.organization_id] = permission.authlevel.to_i
      end
    end

    # FIXME:
    if @is_cesia && (o = ::Organization.first)
      @@authlevels_cache[k][o.id] = TO_CESIA
    end
  end

  def each_network
    net = @client_ip.split(".") # net[0]=137 net[1]=204 net[2]=134 net[3]=32
    raise Gemma::SystemError, "problemi con client_ip=#{client_ip}" unless net.length == 4

    ["#{net[0]}.0.0.0", "#{net[0]}.#{net[1]}.0.0", "#{net[0]}.#{net[1]}.#{net[2]}.0", @client_ip].each do |network|
      yield(network)
    end
  end
end
