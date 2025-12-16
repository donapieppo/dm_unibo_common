# frozen_string_literal: true

class DmUniboCommon::FooterComponent < ViewComponent::Base
  include DmUniboCommon::IconHelper

  def initialize(current_user, documentation_path: nil, contact_mail: nil, contacts_path: nil)
    @current_user = current_user
    @documentation_path = documentation_path
    @contact_mail = contact_mail
    @contacts_path = contacts_path
  end
end
