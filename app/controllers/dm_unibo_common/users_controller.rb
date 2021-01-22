module DmUniboCommon
class UsersController < ::ApplicationController
  layout 'dm_unibo_common_layout'
  before_action :check_user_is_cesia
  before_action :get_organization_and_check_permission, only: [:show, :edit, :update, :destroy]
  skip_after_action :verify_authorized

  def index
    request.remote_ip == '137.204.134.32' or raise 
    @users = ::User.order(:surname, :name)
  end

  def new
    request.remote_ip == '137.204.134.32' or raise 
    @user = ::User.new
  end

  def create
    request.remote_ip == '137.204.134.32' or raise 
    #if r = /\A(\w+\.\w+)(@unibo.it)?\z/.match(params[:upn])
    #  upn = r[1] + '@unibo.it'
      upn = params[:upn]
      begin
        ::User.syncronize(upn)
      rescue DmUniboCommon::NoUser
        flash[:alert] = "Non esiste l'utente #{upn} nel database di Ateneo."
      end
    #end
    redirect_to users_path
  end
end
end
