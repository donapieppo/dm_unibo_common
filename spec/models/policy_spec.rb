require 'rails_helper'

module DmUniboCommon
RSpec.describe ApplicationPolicy, type: :model do
  let(:user) { FactoryBot.create(:current_user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }
  let(:thing1) { FactoryBot.create(:thing, organization: org1) }
  let(:thing2) { FactoryBot.create(:thing, organization: org2) }

  context "when current_user has permission org1 with authlevel 2" do
    let!(:permission) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 2) }

    it ".record_organization_manager? on thing1 is true" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing1).record_organization_manager?).to be_truthy 
    end

    it ".record_organization_manager? on thing2 is false" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing2).record_organization_manager?).to be_falsey
    end
  end
end
end

