require "dm_unibo_user_search"

module DmUniboCommon::User
  extend ActiveSupport::Concern

  included do
    has_many :permissions, class_name: "DmUniboCommon::Permission"

    validates :email, uniqueness: {case_sensitive: false}, allow_blank: true
    validates :upn, uniqueness: {case_sensitive: false}, allow_blank: true
  end

  def cn
    "%s %s" % [name, surname]
  end

  def cn_militar
    "%s, %s" % [surname, name]
  end

  def abbr
    "%s. %s" % [name[0], surname]
  end

  # after create admin withouth searchable_provider name, sn are blank and we show email/upn
  def to_s
    if surname.blank?
      upn
    else
      cn
    end
  end

  def mail
    upn
  end

  def is_cesia?
    Rails.configuration.unibo_common.superusers.include?(upn)
  end

  # example book with has_and_belongs_to_many
  # user.owns?(book) if book.user_ids.include?(user.id)
  def owns?(what)
    if what.respond_to?(:user_ids)
      return what.user_ids.include?(id)
    elsif what.respond_to?(:user_id)
      return what.user_id == id
    end
    return is_cesia?
  end

  def owns!(what)
    self.owns?(what) or raise DmUniboCommon::NoAccess
  end

  # ClassMethods

  module ClassMethods
    # if ADMINS exists
    def admin_mails
      ADMINS
    end

    def dm_unibo_user_search_client
      @@dsa ||= DmUniboUserSearch::Client.new(Rails.configuration.unibo_common.search_wsdl_file)
    end

    def search(str)
      dm_unibo_user_search_client.find_user(str)
    end

    # Always asks to remote, updates user data or eventually create new user
    # to mantain old compatibility
    def syncronize(upn_or_id, c = User)
      syncronize_with_select(upn_or_id, nil, c)
    end

    # Always asks to remote, updates user data or eventually create new user
    # accept a third parameter with a proc to select users
    # syncronize_with_select(12324, User, -> (u) {u.upn.name == 'Pietro')
    # FIXME does actually not update values from remote to local
    def syncronize_with_select(upn_or_id, select_proc = nil, c = User)
      Rails.logger.info("Asked to syncronize '#{upn_or_id}' in '#{c}' class")
      upn_or_id.blank? and raise DmUniboCommon::NoUser

      upn = id = false
      if upn_or_id.is_a?(Integer) || upn_or_id =~ /^\d+$/
        id = upn_or_id.to_i
      else
        upn = upn_or_id
      end

      # remote search
      result = dm_unibo_user_search_client.find_user(upn_or_id, select_proc)
      if result.count < 1
        raise DmUniboCommon::NoUser
      elsif result.count > 1 && upn
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
      if !local_user
        local_user = c.new({
          id: dsa_user.id_anagrafica_unica,
          upn: dsa_user.upn,
          name: dsa_user.name,
          surname: dsa_user.sn
        })

        if local_user.respond_to?(:uid)
          local_user.uid = dsa_user.sam_account_name
        end

        if local_user.respond_to?(:sam)
          local_user.sam = dsa_user.sam_account_name
        end

        if local_user.respond_to?(:employeeNumber)
          local_user.employeeNumber = dsa_user.employee_id
        end

        local_user.save!
        Rails.logger.info("Created User #{local_user.inspect}")
      end

      local_user
    end

    # User.find_or_syncronize(1203) finds the user by id in local database
    # if user is not in local database it creates it from remote DmUniboUserSearch
    # User.find_or_syncronize('pippo@pluto.com') finds the user by upn/mail in local database
    # if user is not in local database it creates it from remote DmUniboUserSearch
    def find_or_syncronize(upn_or_id, select_proc = nil, c = User)
      if upn_or_id.is_a?(String) && upn_or_id.match?(/^\d+$/)
        upn_or_id = upn_or_id.to_i
      end

      field = upn_or_id.is_a?(Integer) ? :id : :upn
      Rails.logger.info("find_or_syncronize on #{field} with #{upn_or_id}")

      u = User.where(field => upn_or_id).first

      if !u && Rails.configuration.unibo_common.searchable_provider
        u = User.syncronize_with_select(upn_or_id, select_proc, c)
      elsif !u && field == :upn
        u = User.create(upn: upn_or_id, email: upn_or_id)
      end

      u
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
