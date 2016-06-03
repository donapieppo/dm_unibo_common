module DmUniboOrganizationsHelper 
  def check_organization!(obj)
    if (obj.is_a?(Integer))
      (obj == @current_organization.id) or raise DmUniboCommon::MismatchOrganization, "Struttura Sbagliata"
    else
      (obj.organization_id == @current_organization.id) or raise DmUniboCommon::MismatchOrganization, "Struttura Sbagliata"
    end
  end

  def check_user_is_cesia
    current_user.is_cesia? or raise DmUniboCommon::NotAuthorized, "Non sufficienti privilegi per seguire l'operazione"
  end
end

