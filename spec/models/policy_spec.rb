require 'rails_helper'

module DmUniboCommon
RSpec.describe ApplicationPolicy, type: :model do
  let(:user) { FactoryBot.create(:current_user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }
  let(:thing_on_org1) { FactoryBot.create(:thing, organization: org1) }
  let(:thing_on_org2_and_user) { FactoryBot.create(:thing, organization: org2, user: user) }

  context "when current_user has no permissions" do
    it ".record_organization_manager? on thing_on_org1 is false" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing_on_org1).record_organization_manager?).to be_falsey
    end

    it ".owner_or_record_organization_manager? on thing_on_org1 is false" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing_on_org1).owner_or_record_organization_manager?).to be_falsey
    end
  end

  context "when current_user has permission on org1 with authlevel 2" do
    let!(:permission) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 2) }

    it ".record_organization_manager? on thing_on_org1 is true" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing_on_org1).record_organization_manager?).to be_truthy 
    end

    it ".record_organization_manager? on thing_on_org2_and_user is false" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing_on_org2_and_user).record_organization_manager?).to be_falsey
    end
  end

  context "when current_user owns thing_on_org2_and_user" do
    it ".owner_or_record_organization_manager? on thing_on_org1 is true" do
      user.update_authorization_by_ip("1.1.1.1")
      expect(ApplicationPolicy.new(user, thing_on_org2_and_user).owner_or_record_organization_manager?).to be_truthy 
    end
  end
end
end

