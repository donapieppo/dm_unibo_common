# frozen_string_literal: true

class DmUniboCommon::FooterComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(current_user, documentation_path: nil, contact_mail: nil, contacts_path: nil)
    @current_user = current_user
    @documentation_path = documentation_path
    @contact_mail = contact_mail
    @contacts_path = contacts_path
    @privacy_url = Rails.configuration.unibo_common.privacy_url || "http://www.unibo.it/it/ateneo/privacy-e-note-legali/privacy/informative-sul-trattamento-dei-dati-personali"
  end
end
