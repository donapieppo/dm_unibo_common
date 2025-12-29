# frozen_string_literal: true
class DmUniboCommon::MenuComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

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

  # DmUniboCommon::Engine.routes.url_helpers.send("auth_shibboleth_callback_path") => "/dm_unibo_common/auth/shibboleth/callback"
  # Rails.application.routes.url_helpers.send('dm_unibo_common.auth_shibboleth_callback_path') -> undefined method `dm_unibo_common.auth_shibboleth_callback_path'
  # dm_unibo_common.auth_shibboleth_callback_path.inspect -> "/seminari/dm_unibo_common/auth/shibboleth/callback"
  # root_path -> seminari
  def login_link
    txt = dm_icon("sign-in", text: "Login")

    case Rails.configuration.unibo_common.omniauth_provider
    when :shibboleth
      helpers.dm_unibo_common.auth_shibboleth_callback_path
    when :entra_id
      button_to txt, "/dm_unibo_common/auth/entra_id", form: {data: {turbo: false}}
    when :google_oauth2
      button_to txt, "/dm_unibo_common/auth/google_oauth2", form: {data: {turbo: false}}
    when :developer
      button_to txt, "/dm_unibo_common/auth/developer", form: {data: {turbo: false}}
    when :test
      button_to txt, helpers.dm_unibo_common.auth_test_callback_path, form: {data: {turbo: false}}
    end
  end

  def logout_link
    link_to helpers.dm_unibo_common.logout_path, data: {turbo: false} do
      dm_icon("sign-out", text: "Logout")
    end
  end

  def main_root_path
    if @current_organization
      helpers.main_app.current_organization_root_path(__org__: @current_organization.code)
    else
      helpers.main_app.root_path
    end
  end
end
