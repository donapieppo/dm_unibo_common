# frozen_string_literal: true

class DmUniboCommon::MenuComponent < ViewComponent::Base
  include DmUniboCommon::IconHelper
  include DmUniboCommon::MenuHelper

  def initialize(
    sso_user_upn,
    current_organization: nil,
    header_title: Rails.configuration.unibo_common.header_title,
    header_subtitle: Rails.configuration.unibo_common.header_subtitle,
    search_component: nil
  )
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

  def main_root_path
    if @current_organization
      helpers.main_app.current_organization_root_path(__org__: @current_organization.code)
    else
      helpers.main_app.root_path
    end
  end
end
