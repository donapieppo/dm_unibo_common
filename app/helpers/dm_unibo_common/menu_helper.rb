module DmUniboCommon::MenuHelper
  # DmUniboCommon::Engine.routes.url_helpers.send("auth_shibboleth_callback_path") => "/dm_unibo_common/auth/shibboleth/callback"
  # Rails.application.routes.url_helpers.send('dm_unibo_common.auth_shibboleth_callback_path') -> undefined method `dm_unibo_common.auth_shibboleth_callback_path'
  # dm_unibo_common.auth_shibboleth_callback_path.inspect -> "/seminari/dm_unibo_common/auth/shibboleth/callback"
  # root_path -> seminari
  def login_link
    txt = dm_icon("sign-in", text: "Login")

    case Rails.configuration.unibo_common.omniauth_provider
    when :shibboleth
      dm_unibo_common.auth_shibboleth_callback_path
    when :entra_id
      button_to txt, "/dm_unibo_common/auth/entra_id", form: {data: {turbo: false}}
    when :azure_activedirectory_v2
      button_to txt, "/dm_unibo_common/auth/azure_activedirectory_v2", form: {data: {turbo: false}}
    when :google_oauth2
      button_to txt, "/dm_unibo_common/auth/google_oauth2", form: {data: {turbo: false}}
    when :developer
      button_to txt, "/dm_unibo_common/auth/developer", form: {data: {turbo: false}}
    when :test
      button_to txt, dm_unibo_common.auth_test_callback_path, form: {data: {turbo: false}}
    end
  end

  def logout_link
    link_to dm_unibo_common.logout_path, data: {turbo: false} do
      dm_icon("sign-out", text: "Logout")
    end
  end

  def dropdown_menu(id, title, &block)
    raw %(
<li class="nav-item dropdown" data-bs-theme="light">
  <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown#{id}" role="button" data-bs-toggle="dropdown" aria-expanded="false">
    #{title}
  </a>
  <ul class="dropdown-menu" aria-labelledby="navbarDropdown#{id}">
    #{capture(&block)}
  </ul>
</li>)
  end
end
