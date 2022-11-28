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

  def toggle_button
    raw %Q|
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    |
  end

  def dm_menu(&block)
    raw %Q|
<nav class="dm-navbar">
  <div class="container-fluid">
    #{toggle_button} | + capture(&block) + %Q|
  </div>
</nav>| + privacy_alert
  end

  def dm_header(dm_header_title: Rails.configuration.header_title, dm_header_subtitle: Rails.configuration.header_subtitle)
    main_root_path = current_organization ? main_app.current_organization_root_path : main_app.root_path

    string = (dm_header_title) + content_tag(:div, dm_header_subtitle, style: 'font-size: 75%')

    link_to(image_tag(Rails.configuration.dm_unibo_common[:logo_image]), Rails.configuration.dm_unibo_common[:logo_page], class: 'navbar-brand') +
    link_to(big_dmicon(Rails.configuration.header_icon), main_root_path, class: 'navbar-brand navbar-icon', data: { turbo: false }) +
    link_to(string.html_safe, main_root_path, class: 'navbar-brand', data: { turbo: false }) 
  end

  def dm_nav(&block)
    %Q|<div class="collapse navbar-collapse" id="navbarSupportedContent">
         <ul class="navbar-nav me-auto">|.html_safe + capture(&block) +
    %Q|  </ul> |.html_safe + logged_user +
    %Q|</div>|.html_safe
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

  def dm_footer
    raw %Q|
    <div id="footer" role="navigation">
      <div class="container" style="text-align: center">
        &mdash; <strong><a href="http://www.matematica.unibo.it">Dipartimento di Matematica</a></strong> &mdash;<br/>
        <a href="http://www.unibo.it">Università di Bologna</a><br/>
        Piazza di Porta San Donato, 5 - 40126 Bologna<br/>
        Per problemi di carattere tecnico contattare #{support_mail}<br/>
        <a href="http://www.unibo.it/it/ateneo/privacy-e-note-legali/privacy/informative-sul-trattamento-dei-dati-personali">Privacy</a><br/>
        #{stop_impersonation_link} #{start_impersonation_link}
      </div>
    </div>|
  end
end
