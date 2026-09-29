# frozen_string_literal: true

class DmUniboCommon::FooterComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(current_user, documentation_path: nil)
    @current_user = current_user
    @documentation_path = documentation_path
    @contact_mail = Rails.configuration.unibo_common.contact_mail
    @contact_tel = Rails.configuration.unibo_common.contact_tel
    @contact_description = Rails.configuration.unibo_common.contact_description
    @privacy_url = Rails.configuration.unibo_common.privacy_url || "http://www.unibo.it/it/ateneo/privacy-e-note-legali/privacy/informative-sul-trattamento-dei-dati-personali"
  end
end
