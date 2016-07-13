Rails.application.config.middleware.use OmniAuth::Builder do
  # donatini
  # :request_type => 'header' necessario con passenger 5 che non setta piu' in env
  # "eppn"=>"pippo.pluto@unibo.it" etc etc
  provider :shibboleth, {
    request_type: 'header', 
    uid_field:    'eppn',
    info_fields:  { email:     'eppn', 
                    name:      'givenName', 
                    last_name: 'sn' },
                    extra_fields: [:idAnagraficaUnica, :isMemberOf, :codiceFiscale] }

  provider :google_oauth2, ENV['GOT_GOOGLE_APP_ID'], ENV['GOT_GOOGLE_APP_SECRET'], { scope: "email" }
  provider :developer, { 
    fields: [:upn, :name, :surname],
    uid_field: :upn
  }

end
