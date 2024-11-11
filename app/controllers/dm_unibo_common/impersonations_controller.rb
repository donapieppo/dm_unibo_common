module DmUniboCommon
class ImpersonationsController < ::ApplicationController
  skip_before_action :after_current_user_and_organization
  skip_after_action :verify_authorized

  layout "dm_unibo_common_layout"
  def who_impersonate
    if true_user_can_impersonate?
      @users = ::User.order(:surname)
      @main_users = ::User.where(upn: Rails.configuration.unibo_common.main_impersonations || [])
    else
      redirect_to main_app.root_path and return
    end
  end

  def impersonate
    if true_user_can_impersonate?
      user = ::User.find(params[:id])
      logger.info("IMPERSONATION: #{current_user.inspect} -> #{user.inspect}")
      session[:new_impersonation] = true
      impersonate_user(user)
    end

    redirect_to main_app.root_path(__org__: nil) and return
  end

  # do not require admin for this method if access control
  # is performed on the current_user instead of true_user
  def stop_impersonating
    authorize :impersonation, policy_class: DmUniboCommon::ImpersonationPolicy
    stop_impersonating_user
    redirect_to main_app.root_path(__org__: nil) and return
  end

  private

  # config.unibo_common.impersonate_admins = ['user.one@unibo.it', 'user.two@unibo.it']
  def true_user_can_impersonate?
    true_user && Rails.configuration.unibo_common.impersonate_admins && Rails.configuration.unibo_common.impersonate_admins.include?(true_user.upn)
  end
end
end
