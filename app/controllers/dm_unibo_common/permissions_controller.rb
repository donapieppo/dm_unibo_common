module DmUniboCommon
class PermissionsController < ::ApplicationController
  layout "dm_unibo_common_layout"
  before_action :check_user_is_cesia

  def index
    if params[:organization_id]
      @organizations = [::Organization.find(params[:organization_id])]
    else
      @organizations = ::Organization.includes(permissions: :user).order(:name)
      @networks = Permission.where.not(network: nil).includes(:organization)
    end
    authorize :permission, policy_class: DmUniboCommon::PermissionPolicy
  end

  def show
    @permission = Permission.find(params[:id])
    authorize @permission
  end

  def new
    @organization = ::Organization.find(params[:organization_id])
    @permission = @organization.permissions.new
    authorize @permission
  end

  def create
    @organization = ::Organization.find(params[:organization_id])
    @permission = @organization.permissions.new(
      user_upn: params[:permission][:user_upn],
      authlevel: params[:permission][:authlevel]
    )
    authorize @permission
    if @permission.save
      redirect_to permissions_path(organization_id: @organization.id), notice: "OK"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    @organization = @permission.organization
    authorize @permission
    if @permission.destroy
      flash[:notice] = "OK."
    else
      flash[:error] = "Non è stato possibile eliminare l'autorizzazione."
    end
    redirect_to organization_permissions_path(@organization)
  end
end
end
