module DmUniboCommon
class Authorization
  TO_READ   = 1
  TO_MANAGE = 2
  TO_CESIA  = 3

  # @@authlevel[123][46] = DmUniboCommon::Authorization::TO_ADMIN 
  # means that user 123 can admin organization with id=46
  attr_reader :authlevels

  # @@authlevel[123][46] = DmUniboCommon::Authorization::TO_ADMIN 
  # means that user 123 can admin organization with id=46
  @@authlevels_cache = Hash.new{|h, k| h[k] = {}}

  # Authorization depends on client ip and user
  def initialize(client_ip, user)
    @user      = user
    @client_ip = client_ip
    @is_cesia  = CESIA_UPN.include?(@user.upn) 

    update_authlevels_cache_by_user(@user)

    @authlevels = @@authlevels_cache[@user.id] || {}
  end

  # to clear cache !!!!
  def self.authlevels_reload!
    @@authlevels_cache = Hash.new{|h, k| h[k] = {}}
  end

  def has_authorization?
    @authlevels && @authlevels.size > 0
  end
  
  # multi_organizations?: false/true if user has access to more than one organization
  def multi_organizations?
    @authlevels && @authlevels.size > 1 
  end

  def organizations
    Organization.order(:name).find(@authlevels.keys)
  end

  def authlevel(o)
    i = o.is_a?(Organization) ? o.id : o
    @authlevels[i]
  end

  def first_organization_id
    @authlevels.keys.first
  end

  # per visualizzazione livelli di autorizzazione
  def self.level_description(level, html=1)
    case level
      when TO_READ
        I18n.t(:can_read)
      when TO_MANAGE
        I18n.t(:can_manage)
      when TO_CESIA
        I18n.t(:is_cesia)
    end
  end

  # TO_CESIA only by file configuration 
  def self.all_level_list
    [TO_READ, TO_MANAGE]
  end

  def can_read?(oid)
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_READ
  end

  def can_manage?(oid)
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_MANAGE
  end

  def is_cesia?
    @is_cesia
  end

  private 

  # vince sempre il net piu' specifico (tra 137.204.134.0 e 137.204.0.0 vince il primo)
  # per quanto riguarda la stessa struttura
  #
  # aggiorna @authlevels in base all'ip
  def update_authlevels_by_ip(client_ip)
  end

  # se c'e' la rete nel database allora aggiorno con quello che trovo
  def update_authlevels_by_network(net)
  end

  # un user puo' essere in diverse organizations con diversi authlevels
  # se si trova nel database admin sovrascrivo authlevel di update_authlevels_by_network
  def update_authlevels_cache_by_user(user)
    return @@authlevels_cache[user.id] if @@authlevels_cache.key?(user.id)

    user.permissions.each do |permission|
      if @is_cesia
        @@authlevels_cache[user.id][permission.organization_id] = TO_CESIA
      else
        @@authlevels_cache[user.id][permission.organization_id] = permission.authlevel.to_i
      end
    end
    # FIXME
    if @is_cesia and o = ::Organization.first
      @@authlevels_cache[user.id][o.id] = TO_CESIA
    end
  end
end
end
