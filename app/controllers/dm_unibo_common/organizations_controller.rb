module DmUniboCommon
class OrganizationsController < ::ApplicationController
  before_action :check_user_is_cesia
  before_action :get_organization_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = ::Organization.order(:name)
    authorize :organization, policy_class: DmUniboCommon::OrganizationPolicy
  end

  # *** okkio all'@organization in sessione che compare in hedaer della pagina ***
  def new
    @organization = ::Organization.new
    authorize @organization, policy_class: DmUniboCommon::OrganizationPolicy
  end

  def create
    @organization = ::Organization.new(organization_params)
    authorize @organization, policy_class: DmUniboCommon::OrganizationPolicy
    if @organization.save
      redirect_to organizations_path, notice: 'La struttura è stata creata.' 
    else
      render action: :new
    end
  end

  # def edit
  # end

  # def update
  #   if @organization.update_attributes(organization_params)
  #     u = current_user.is_cesia? ? organizations_path : edit_organization_path(@organization)
  #     redirect_to u, notice: 'La Struttura è stata modificata.'
  #   else
  #     render action: :edit
  #   end
  # end

  def show
  end

  def destroy
  end

  private

  # except for cesia can edit current_organization
  def get_organization_and_check_permission
    @organization = current_user.is_cesia? ? ::Organization.find(params[:id]) : current_organization
    authorize @organization
  end

  def organization_params
    p =  []
    p += [:code, :name, :description, :booking] if current_user.is_cesia?
    params[:organization].permit(p)
  end
end
end
