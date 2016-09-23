require 'dm_unibo_user_search'

module DmUniboCommon::User

  # validates :email, uniqueness: {}
  # validates :upn, uniqueness: {}
  # default_scope { order("users.surname, users.name") }

  def cn
    "%s %s" % [self.name, self.surname]
  end

  def cn_militar
    "%s %s" % [self.surname, self.name]
  end

  def abbr
    "%s %s" % [self.name[0], self.surname]
  end

  # after create admin withouth searchable_provider name, sn are blank and we show email/upn
  def to_s
    if self.surname.blank?
      self.upn
    else
      self.cn
    end
  end

  def description
    self.cn
  end

  def mail
    self.upn
  end

  # Fast Authorizations
  def is_cesia?
    CESIA_UPN.include?(self.upn)
  end
 
  def is_admin?
    ADMINS.include?(self.upn)
  end
  alias_method :admin?, :is_admin?

  def is_chief?
    self.upn == CHIEF
  end

  # example book with has_and_belongs_to_many
  # user.owns?(book) if book.user_ids.include?(user.id)
  def owns?(what)
    if what.respond_to?(:user_ids)
      return what.user_ids.include?(self.id)
    elsif what.respond_to?(:user_id)
      return what.user_id == self.id
    end
    false
  end
  
  def owns!(what)
    self.owns?(what) or raise DmUniboCommon::NoAccess
  end

  #
    
  module ClassMethods
    def admin_mails 
      ADMINS
    end

    def dsaSearchClient
      @@dsa ||= DmUniboUserSearch::Client.new
    end

    def search(str)
      dsaSearchClient.find_user(str)
    end

    # Always asks to remote, updates user data or eventually create new user
    def syncronize(upn_or_id, c = User)
      Rails.logger.info("Asked to syncronize '#{upn_or_id}' in '#{c}' class")
      upn_or_id.blank? and raise DmUniboCommon::NoUser

      upn = id = false
      if upn_or_id.is_a? Integer or upn_or_id =~ /^\d+$/
        id = upn_or_id.to_i
      else
        upn = upn_or_id
      end

      # remote search 
      result = dsaSearchClient.find_user(upn_or_id)
      if result.count < 1
        raise DmUniboCommon::NoUser
      elsif result.count > 1 and upn
        raise DmUniboCommon::TooManyUsers
      end        

      # remote user
      dsa_user = nil
      # if id was given we still have to check that the search resul did not get new results with 
      # id equal to other numeric fields like matricola...
      if id 
        result.users.each do |u|
          if u.id_anagrafica_unica.to_i == id
            dsa_user = u 
            break
          end
        end
        dsa_user or raise DmUniboCommon::NoUser
      else
        dsa_user = result.users.first
      end

      # local user
      local_user = c.where(id: dsa_user.id_anagrafica_unica).first
      if ! local_user
        local_user = c.new({id:      dsa_user.id_anagrafica_unica,
                            upn:     dsa_user.upn,
                            name:    dsa_user.name,
                            surname: dsa_user.sn})
        local_user.save!
        Rails.logger.info("Created User #{local_user.inspect}")
      end

      local_user
    end

    # User.find_or_syncronize(1203) finds the user by id in local database
    # if user is not in local database it creates it from remote DmUniboUserSearch
    # User.find_or_syncronize('pippo@pluto.com') finds the user by upn/mail in local database
    # if user is not in local database it creates it from remote DmUniboUserSearch
    def find_or_syncronize(upn_or_id)
      upn_or_id = upn_or_id.to_i if upn_or_id =~ /^\d+$/

      field = upn_or_id.is_a?(Integer) ? :id : :upn
      u = User.where(field => upn_or_id).first

      if Rails.configuration.dm_unibo_common[:searchable_provider]
        u ||= User.syncronize(upn_or_id)
      elsif field == :upn
        u ||= User.create(upn: upn_or_id, email: upn_or_id)
      end
    end

  end

  def self.included(base)
    base.extend ClassMethods
  end
end

