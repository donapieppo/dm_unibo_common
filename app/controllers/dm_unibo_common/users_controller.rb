module DmUniboCommon
  class UsersController < ::ApplicationController
    layout "dm_unibo_common_layout"
    before_action :current_user_cesia!

    def index
      authorize :user, policy_class: DmUniboCommon::UserPolicy
      @users = ::User.order(:surname, :name)
    end

    def new
      authorize :user, policy_class: DmUniboCommon::UserPolicy
      @user = ::User.new
    end

    def create
      authorize :user, policy_class: DmUniboCommon::UserPolicy
      upn = params[:upn]
      begin
        ::User.syncronize(upn)
      rescue DmUniboCommon::NoUser
        flash[:alert] = "Non esiste l'utente #{upn} nel database di Ateneo."
      end

      redirect_to users_path
    end
  end
end
