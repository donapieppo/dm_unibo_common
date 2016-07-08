class LoginsController < ApplicationController
  skip_before_filter :force_sso_user, :redirect_unsigned_user, :check_role, :retrive_authlevel, only: :no_access
  # Check if there is no signed in user before doing the sign out to be skipped for shibboleth logout
  # succedeva Filter chain halted as :verify_signed_out_user rendered or redirected
  skip_before_filter :verify_signed_out_user

  # Not authorized but valid credentials
  def no_access
  end
end

