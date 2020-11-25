require 'rails_helper'

# current_user is a user extended with DmUniboCommon::CurrentUser 
RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user).extend(DmUniboCommon::CurrentUser) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  it ".authorization is not" do
    expect(user.authorization).not_to be
  end

  it ".update_authorization_by_ip updates .authorization to DmUniboCommon::Authorization" do
    user.update_authorization_by_ip('1.1.1.1')
    expect(user.authorization).to be_a(DmUniboCommon::Authorization)
  end
end
