require "dm_unibo_user_search"

module DmUniboCommon::User
  extend ActiveSupport::Concern

  included do
    has_many :permissions, class_name: "DmUniboCommon::Permission"

    validates :email, uniqueness: {case_sensitive: false}, allow_blank: true
    validates :upn,
      uniqueness: {case_sensitive: false},
      format: {with: /\A[^@\s]+@[^@\s]+\z/, message: :invalid},
      allow_blank: true
  end

  def cn
    if surname.blank?
      upn
    else
      "%s %s" % [name, surname]
    end
  end

  def cn_militar
    if surname.blank?
      upn
    else
      "%s, %s" % [surname, name]
    end
  end

  def abbr
    if surname.blank?
      upn
    else
      "%s. %s" % [name[0], surname]
    end
  end

  # after create admin withouth searchable_provider name, sn are blank and we show email/upn
  def to_s
    cn
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
    is_cesia?
  end

  def owns!(what)
    owns?(what) or raise DmUniboCommon::NoAccess
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
    # accept a third parameter with a proc to select users
    # search_and_syncronize_from_remote(12324, User, -> (u) {u.upn.name == 'Pietro')
    # FIXME does actually not update values from remote to local
    # can raise DmUniboCommon::NoUser, DmUniboCommon::TooManyUsers
    # select_proc is passed to dm_unibo_user_search_client.find_user
    def search_and_syncronize_from_remote(upn_or_id, select_proc = nil, c = User)
      Rails.logger.info("dm_unibo_common User.search_and_syncronize_from_remote '#{upn_or_id}' in '#{c}' class")
      upn_or_id.blank? and raise DmUniboCommon::NoUser

      # :upn or :id with value
      search_field, search_value = extract_query_field_and_value(upn_or_id)

      # if we search on upn there should be only one result (or we raise DmUniboCommon::TooManyUsers)
      search_result = dm_unibo_user_search_client.find_user(upn_or_id, select_proc)
      if search_result.count < 1
        raise DmUniboCommon::NoUser
      elsif search_result.count > 1 && search_field == :upn
        raise DmUniboCommon::TooManyUsers
      end

      remote_user = nil
      # if id was given we still have to check that the search resul did not get new results with
      # id equal to other numeric fields like matricola...
      if search_field == :id
        search_result.users.each do |u|
          if u.id_anagrafica_unica.to_i == search_value
            remote_user = u
            break
          end
        end
        remote_user or raise DmUniboCommon::NoUser
      else
        remote_user = search_result.users.first
      end

      remote_user or raise DmUniboCommon::NoUser

      User.create_from_remote_user(remote_user, c)
    end

    def create_from_remote_user(remote_user, c)
      local_user = c.find_by(id: remote_user.id_anagrafica_unica)

      if !local_user
        local_user = c.new({
          id: remote_user.id_anagrafica_unica,
          upn: remote_user.upn,
          name: remote_user.name,
          surname: remote_user.sn
        })

        local_user.uid = remote_user.sam_account_name if local_user.respond_to?(:uid)
        local_user.sam = remote_user.sam_account_name if local_user.respond_to?(:sam)
        local_user.employeeNumber = remote_user.employee_id if local_user.respond_to?(:employeeNumber)

        local_user.save!
        Rails.logger.info("dm_unibo_common User.create_from_remote_user: created User #{local_user.inspect}")
      end

      local_user
    end

    # Finds the user by id or upn in database or create it
    # User.find_or_syncronize(1203) finds the user by id in local database
    # User.find_or_syncronize('pippo@pluto.com') finds the user by upn/mail in local database
    # if user is not in local database and i have upn then
    # - Rails.configuration.unibo_common.searchable_provider == true => creates it from remote DmUniboUserSearch 
    # - Rails.configuration.unibo_common.searchable_provider == false => trusts the upn and creates user without name/surname
    def find_or_syncronize(upn_or_id, select_proc = nil, c = User)
      search_field, search_value = extract_query_field_and_value(upn_or_id)
      Rails.logger.info("dm_unibo_common user find_or_syncronize on #{upn_or_id} -> #{search_field}:#{search_value}")

      u = User.find_by(search_field => search_value)

      if !u
        if Rails.configuration.unibo_common.searchable_provider
          u = User.search_and_syncronize_from_remote(upn_or_id, select_proc, c)
        elsif search_field == :upn
          u = User.create!(upn: search_value, email: search_value)
        end
      end

      u
    end

    # old compatibility
    def syncronize(upn_or_id)
      find_or_syncronize(upn_or_id)
    end

    private

    # the search gets upn_or_id this function extract it with correct name and value
    # if upn and upn odes not have @ => adds @domain
    # (upn must match email format or username to add domain)
    def extract_query_field_and_value(upn_or_id)
      if upn_or_id.is_a?(Integer) || (upn_or_id.is_a?(String) && upn_or_id.match?(/^\d+$/))
        [:id, upn_or_id.to_i]
      elsif upn_or_id.is_a?(String)
        sanitized_value = upn_or_id.strip
        raise DmUniboCommon::NoUser if sanitized_value.empty?

        email_match = sanitized_value.match(/\b[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}\b/i)
        if email_match
          sanitized_value = email_match[0]
        elsif sanitized_value.match?(/\A[A-Z0-9._+\-]+\z/i)
          sanitized_value = "#{sanitized_value}@#{Rails.configuration.unibo_common.domain}"
        else
          raise DmUniboCommon::NoUser
        end

        [:upn, sanitized_value]
      else
        raise DmUniboCommon::NoUser
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
