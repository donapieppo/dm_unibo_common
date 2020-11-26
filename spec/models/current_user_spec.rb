require 'rails_helper'

# current_user is a user extended with DmUniboCommon::CurrentUser 
RSpec.describe DmUniboCommon::CurrentUser, type: :model do
  let(:current_user) { FactoryBot.create(:user).extend(DmUniboCommon::CurrentUser) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  it '.authorization is not' do
    expect(current_user.authorization).not_to be
  end

  it '.current_organization is not' do
    expect(current_user.current_organization).not_to be
  end

  it '.update_authorization_by_ip updates .authorization to DmUniboCommon::Authorization' do
    current_user.update_authorization_by_ip('1.1.1.1')
    expect(current_user.authorization).to be_a(DmUniboCommon::Authorization)
  end

  # current_organization is set/updated by controllers
  it '.update_authorization_by_ip does not update .current_organization' do
    current_user.update_authorization_by_ip('1.1.1.1')
    expect(current_user.current_organization).not_to be
  end

  it 'can set current_organization' do
    expect(current_user.current_organization = org1).to be
    expect(current_user.current_organization).to eq(org1)
  end
end
