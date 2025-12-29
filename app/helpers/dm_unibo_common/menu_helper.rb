module DmUniboCommon::MenuHelper
  def login_link_title
    content_tag :h3, class: "my-3" do
      "Per accedere usare le credenziali di Ateneo."
    end
  end

  # DmUniboCommon::Engine.routes.url_helpers.send("auth_shibboleth_callback_path") => "/dm_unibo_common/auth/shibboleth/callback"
  # Rails.application.routes.url_helpers.send('dm_unibo_common.auth_shibboleth_callback_path') -> undefined method `dm_unibo_common.auth_shibboleth_callback_path'
  # dm_unibo_common.auth_shibboleth_callback_path.inspect -> "/seminari/dm_unibo_common/auth/shibboleth/callback"
  # root_path -> seminari
  def login_link(btn: false)
    txt = dm_icon("sign-in", text: "Login")
    form_class = btn ? "btn btn-primary" : ""

    case Rails.configuration.unibo_common.omniauth_provider
    when :shibboleth
      dm_unibo_common.auth_shibboleth_callback_path
    when :entra_id
      button_to txt, "/dm_unibo_common/auth/entra_id", form: {data: {turbo: false}}, class: form_class
    when :google_oauth2
      button_to txt, "/dm_unibo_common/auth/google_oauth2", form: {data: {turbo: false}}, class: form_class
    when :developer
      Rails.env.development? or raise "Developer login not in development"
      button_to txt, "/dm_unibo_common/auth/developer", form: {data: {turbo: false}}, class: form_class
    when :test
      Rails.env.test? or raise "Test login not in test"
      button_to txt, dm_unibo_common.auth_test_callback_path, form: {data: {turbo: false}}, class: form_class
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
