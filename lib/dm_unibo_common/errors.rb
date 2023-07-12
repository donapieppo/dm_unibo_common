module DmUniboCommon
  class NotOwner < RuntimeError; end

  class NotAuthorized < RuntimeError; end

  class NoAccess < RuntimeError; end

  class MismatchOrganization < RuntimeError; end

  class NoUser < RuntimeError
    def to_s
      I18n.t "dm_unibo_common.no_user"
    end
  end

  class TooManyUsers < RuntimeError
    def to_s
      I18n.t "dm_unibo_common.too_many_users"
    end
  end

  class WrongOauthMethod < RuntimeError; end
end
