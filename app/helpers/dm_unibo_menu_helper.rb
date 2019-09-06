module DmUniboMenuHelper

  # example user_google_oauth2_omniauth_authorize_path
  def login_link
    url = send('auth_' + Rails.configuration.dm_unibo_common[:omniauth_provider].to_s + '_callback_path')
    link_to image_tag(Rails.configuration.dm_unibo_common[:login_icon]) + content_tag(:strong, ' Login'), url
  end

  def logout_link
    link_to image_tag(Rails.configuration.dm_unibo_common[:logout_icon]) + content_tag(:strong, ' Logout'), 
            Rails.configuration.dm_unibo_common[:logout_link]
  end

  def logged_user
    content_tag :ul, class: "navbar-nav" do 
      if sso_user_upn
        %Q|<span class="navbar-text">#{sso_user_upn}</span>
           <li>#{logout_link}</li>|.html_safe
      else
        %Q|<li>#{login_link}</li>|.html_safe
      end
    end
  end

  def toggle_button
    raw %Q|<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#bs-navbar-collapse" aria-controls="bs-navbar-collapse" aria-expanded="false" aria-label="Toggle navigation"> <span class="navbar-toggler-icon"></span></button>|
  end

  def dm_menu(&block)
    raw %Q|<nav class="dm-navbar"> #{toggle_button} | + capture(&block) + %Q|</nav>| + privacy_alert
  end

  def dm_header(dm_header_title: Rails.configuration.header_title, dm_header_subtitle: Rails.configuration.header_subtitle)
    string = (dm_header_title) + content_tag(:small, dm_header_subtitle)

    link_to(image_tag(Rails.configuration.dm_unibo_common[:logo_image]), Rails.configuration.dm_unibo_common[:logo_page], class: 'navbar-brand navbar-image') +
    link_to(big_dmicon(Rails.configuration.header_icon), root_path, class: 'navbar-brand navbar-icon') +
    link_to(string.html_safe, root_path, class: 'navbar-brand') 
  end

  def dm_nav(&block)
    %Q|<div class="collapse navbar-collapse" id="bs-navbar-collapse">
         <ul class="navbar-nav mr-auto">|.html_safe + capture(&block) +
    %Q|  </ul> |.html_safe + logged_user +
    %Q|</div>|.html_safe
  end

  def dropdown_menu(id, title, &block)
    raw %Q|
<li class="nav-item dropdown">
  <a class="nav-link dropdown-toggle" href="#" id="#{id}" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">#{title}</a>
  <div class="dropdown-menu" aria-labelledby="#{id}">| +
    capture(&block) + %Q|
  </div>
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

