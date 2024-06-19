# frozen_string_literal: true

class DmUniboCommon::MenuComponent < ViewComponent::Base
  def initialize(sso_user_upn, current_organization: nil, header_title: Rails.configuration.header_title, header_subtitle: Rails.configuration.header_subtitle, search_component: nil)
    @sso_user_upn = sso_user_upn
    @current_organization = current_organization
    @header_title = header_title
    @header_subtitle = if current_organization && !header_subtitle
      current_organization.description
    else
      header_subtitle
    end
    @search_component = search_component
  end
end
