class LoginsController < ApplicationController
  skip_before_filter :force_sso_user, :check_role, :retrive_authlevel, :user_logged_not_raise!, :check_allowed, only: :no_access
  # Check if there is no signed in user before doing the sign out to be skipped for shibboleth logout
  # succedeva Filter chain halted as :verify_signed_out_user rendered or redirected
  skip_before_filter :verify_signed_out_user

  # Not authorized but valid credentials
  def no_access
  end
end

