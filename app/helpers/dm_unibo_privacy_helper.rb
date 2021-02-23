module DmUniboPrivacyHelper 
  def privacy_cookie_name
    (Rails.configuration.session_options[:key] + "_privacy").to_sym
  end

  def privacy_alert
    name = privacy_cookie_name
    if cookies[name] 
      return ""
    else
      cookies[name] = { value: "accepted", expires: 1.year.from_now }
      raw %Q|
      <div class="alert alert-warning alert-dismissible" role="alert">
        Questo sito utilizza solo cookie tecnici per il corretto funzionamento delle pagine web e per il miglioramento dei servizi.<br/>
        Se vuoi saperne di più o negare il consenso consulta <a  href="http://www.unibo.it/it/cookies">l'informativa sulla privacy</a>.<br/> 
        Proseguendo la navigazione del sito o cliccando su "chiudi" acconsenti all'uso dei cookie.
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times; chiudi</span>
        </button> 
      </div>|
    end
  end
end
