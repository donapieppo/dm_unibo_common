module DmUniboMenuHelper
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
    end
    link_to image_tag(Rails.configuration.dm_unibo_common[:login_icon]) + content_tag(:strong, ' Login'), url
  end

  def logout_link
    link_to(image_tag(Rails.configuration.dm_unibo_common[:logout_icon]) + content_tag(:strong, ' Logout'), 
            dm_unibo_common.logout_path, 
            data: { turbo: false })
    # Rails.configuration.dm_unibo_common[:logout_link]
  end

  def logged_user
    content_tag :ul, class: "navbar-nav" do 
      if sso_user_upn
        %Q|<span class="navbar-text ps-1">#{sso_user_upn}</span>
           <li>#{logout_link}</li>|.html_safe
      else
        %Q|<li>#{login_link}</li>|.html_safe
      end
    end
  end

  def dm_header(dm_header_title: Rails.configuration.header_title, dm_header_subtitle: Rails.configuration.header_subtitle)
    main_root_path = current_organization ? main_app.current_organization_root_path : main_app.root_path

    string = (dm_header_title) + content_tag(:div, dm_header_subtitle, style: 'font-size: 75%')

    link_to(image_tag(Rails.configuration.dm_unibo_common[:logo_image]), Rails.configuration.dm_unibo_common[:logo_page], class: 'navbar-brand') +
    link_to(big_dmicon(Rails.configuration.header_icon), main_root_path, class: 'navbar-brand navbar-icon', data: { turbo: false }) +
    link_to(string.html_safe, main_root_path, class: 'navbar-brand', data: { turbo: false }) 
  end

  def dropdown_menu(id, title, &block)
    raw %Q|
<li class="nav-item dropdown">
  <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown#{id}" role="button" data-bs-toggle="dropdown" aria-expanded="false">
    #{title}
  </a>
  <ul class="dropdown-menu" aria-labelledby="navbarDropdown#{id}">
    #{capture(&block)}
  </ul>
</li>|
  end
end
