# frozen_string_literal: true

DM_UNIBO_COMMON_PRIVACY_KEY = (Rails.configuration.session_options[:key] + "_privacy").to_sym

module DmUniboCommonPrivacy
  def privacy_alert
    if !cookies[DM_UNIBO_COMMON_PRIVACY_KEY]
      cookies[DM_UNIBO_COMMON_PRIVACY_KEY] = {value: "accepted", expires: 1.year.from_now}
      %(
<div class="container">
  <div class="alert alert-warning alert-dismissible" role="alert">
    Questo sito utilizza solo cookie tecnici per il corretto funzionamento delle pagine web e per il miglioramento dei servizi.<br/>
    Se vuoi saperne di più o negare il consenso consulta <a  href="http://www.unibo.it/it/cookies">l'informativa sulla privacy</a>.<br/>
    Proseguendo la navigazione del sito acconsenti all'uso dei cookie.
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</div>
      ).html_safe
    end
  end
end
