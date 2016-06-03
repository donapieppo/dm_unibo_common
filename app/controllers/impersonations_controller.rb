class ImpersonationsController < ApplicationController
  def who_impersonate
    if true_user_can_impersonate?
      @users = User.order(:surname)
      @main_users = User.where(upn: Rails.configuration.dm_unibo_common[:main_impersonations] || [])
    else
      redirect_to root_path and return 
    end
  end

  def impersonate
    if true_user_can_impersonate?
      user = User.find(params[:id])
      logger.info("IMPERSONATION: #{current_user.inspect} -> #{user.inspect}")
      session[:new_impersonation] = true
      impersonate_user(user)
    end
    redirect_to root_path and return
  end

  # do not require admin for this method if access control
  # is performed on the current_user instead of true_user
  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path and return
  end

  private 

  def true_user_can_impersonate?
    true_user and Rails.configuration.dm_unibo_common[:impersonate_admins] and Rails.configuration.dm_unibo_common[:impersonate_admins].include?(true_user.upn)
  end
end



