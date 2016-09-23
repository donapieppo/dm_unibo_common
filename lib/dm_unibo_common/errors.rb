module DmUniboCommon
  class NotOwner             < RuntimeError; end
  class NotAuthorized        < RuntimeError; end
  class NoAccess             < RuntimeError; end
  class MismatchOrganization < RuntimeError; end

  class NoUser               < RuntimeError; end
  class TooManyUsers         < RuntimeError; end
end



