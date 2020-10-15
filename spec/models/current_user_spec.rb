require 'rails_helper'

# current_user is a user extended with DmUniboCommon::CurrentUser 
RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user).extend(DmUniboCommon::CurrentUser) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  it ".authorization is not" do
    expect(subject.authorization).not_to be
  end

  it ".update_authorization_by_ip updates .authorization to DmUniboCommon::Authorization" do
    subject.update_authorization_by_ip('1.1.1.1')
    expect(subject.authorization).to be_a(DmUniboCommon::Authorization)
  end
end

