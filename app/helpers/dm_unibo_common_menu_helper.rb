module DmUniboCommonMenuHelper
  # DmUniboCommon::Engine.routes.url_helpers.send("auth_shibboleth_callback_path") => "/dm_unibo_common/auth/shibboleth/callback"
  # Rails.application.routes.url_helpers.send('dm_unibo_common.auth_shibboleth_callback_path') -> undefined method `dm_unibo_common.auth_shibboleth_callback_path'
  # dm_unibo_common.auth_shibboleth_callback_path.inspect -> "/seminari/dm_unibo_common/auth/shibboleth/callback"
  # root_path -> seminari
  def login_link
    url = case Rails.configuration.dm_unibo_common[:omniauth_provider]
    when :shibboleth
      dm_unibo_common.auth_shibboleth_callback_path
    when :google_oauth2
      dm_unibo_common.auth_google_oauth2_callback_path
    when :developer
      dm_unibo_common.auth_developer_callback_path
    when :test
      dm_unibo_common.auth_test_callback_path
    end
    link_to image_tag(Rails.configuration.dm_unibo_common[:login_icon]) + content_tag(:strong, " Login"), url
  end

  def logout_link
    link_to(image_tag(Rails.configuration.dm_unibo_common[:logout_icon]) + content_tag(:strong, " Logout"),
      dm_unibo_common.logout_path,
      data: {turbo: false})
    # Rails.configuration.dm_unibo_common[:logout_link]
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
