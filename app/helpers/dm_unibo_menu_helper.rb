module DmUniboMenuHelper
  # example user_google_oauth2_omniauth_authorize_path
  def login_link
    url = send('user_' + Rails.configuration.dm_unibo_common[:omniauth_provider].to_s + '_omniauth_authorize_path')
    link_to image_tag(Rails.configuration.dm_unibo_common[:login_icon]) + content_tag(:strong, ' Login'), url
  end

  def logout_link
    link_to image_tag(Rails.configuration.dm_unibo_common[:logout_icon]) + content_tag(:strong, ' Logout'), 
            Rails.configuration.dm_unibo_common[:logout_link]
  end

  def logged_user
    if user_signed_in? or sso_user_upn
    %Q|<li class="login-name navbar-text">#{sso_user_upn}</li>
       <li class="logout-link">#{logout_link}</li>|.html_safe
    else
      %Q|<li>#{login_link}</li>|.html_safe
    end
  end

  def dm_menu(&block)
    raw %Q|<header class="navbar navbar-default navbar-inverse" role="banner">
             <div class="container">| + capture(&block) + 
        %Q|  </div><!-- container -->
           </header>| + privacy_alert
  end

  def dm_header(icon, title, subtitle = nil)
    string = title + (subtitle ? "<small>#{subtitle}</small>" : "")
    %Q|<div class="navbar-header">
         <button class="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target="#bs-navbar-collapse">
           <span class="sr-only">Toggle navigation</span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>|.html_safe +
    link_to(image_tag(Rails.configuration.dm_unibo_common[:logo_image]), Rails.configuration.dm_unibo_common[:logo_page], class: 'navbar-brand navbar-image') +
    link_to(icon(icon, size: 32), root_path, class: 'navbar-brand navbar-icon') +
    link_to(string.html_safe, root_path, class: 'navbar-brand') +
    %Q|</div><!-- navbar-header -->|.html_safe
  end

  def dm_nav(&block)
    %Q|<nav class="collapse navbar-collapse" id="bs-navbar-collapse">
        <ul class="nav navbar-nav">|.html_safe + capture(&block) +
    %Q| </ul>
       <!-- right -->
       <ul class="nav navbar-nav navbar-right">|.html_safe + logged_user +
    %Q|</ul>
       </nav>|.html_safe
  end

  def dm_footer
    %Q|
    <div id="footer" role="navigation">
      <div class="container" style="text-align: center">
        &mdash; <strong><a href="http://www.matematica.unibo.it">Dipartimento di Matematica</a></strong> &mdash;<br/>
        <a href="http://www.unibo.it">Università di Bologna</a><br/>
        Piazza di Porta San Donato, 5 - 40126 Bologna<br/>
        Per problemi di carattere tecnico contattare #{support_mail}<br/>
        <a href="http://www.unibo.it/it/ateneo/privacy-e-note-legali/privacy/informative-sul-trattamento-dei-dati-personali">Privacy</a><br/>
        #{stop_impersonation_link} #{start_impersonation_link}
      </div>
    </div>|.html_safe
  end

  def dropdown_menu(title, &block)
    raw %Q|<li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">#{title} <b class="caret"></b></a>
      <ul class="dropdown-menu">| + 
      capture(&block) + %Q|
      </ul>
      </li>|
  end

end

