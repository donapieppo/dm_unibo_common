module DmUniboCommon
class PermissionsController < ::ApplicationController
  layout 'dm_unibo_common_layout'
  before_action :check_user_is_cesia

  def index
    if params[:organization_id]
      @organizations = [ ::Organization.find(params[:organization_id]) ]
    else
      @organizations = ::Organization.includes(permissions: :user).order(:name)
    end
    authorize DmUniboCommon::Permission
  end

  def show
    @permission = Permission.find(params[:id])
    authorize @permission
  end

  def new
    @organization = ::Organization.find(params[:organization_id])
    @users = ::User.order('users.surname, users.name')

    @permission = @organization.permissions.new
    authorize @permission
  end

  def create
    @organization = ::Organization.find(params[:organization_id])
    @permission = @organization.permissions.new(user_id:   params[:permission][:user_id], 
                                                authlevel: params[:permission][:authlevel])
    authorize @permission
    if @permission.save
      redirect_to permissions_path, notice: 'OK'
    else
      @users = ::User.order('users.surname, users.name')
      render :new
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    authorize @permission
    if @permission.destroy
      flash[:notice] = "OK."
    else
      flash[:error] = "Non è stato possibile eliminare l'autorizzazione."
    end
    redirect_to permissions_path
  end
end
end
