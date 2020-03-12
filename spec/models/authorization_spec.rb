require 'rails_helper'

module DmUniboCommon
RSpec.describe Authorization, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  it ".has_authorization? should be false" do
    expect(Authorization.new('133.133.133.2', user).has_authorization?).not_to be
  end

  it ".authlevels should be empty" do
    expect(Authorization.new('133.133.133.2', user).authlevels).to be_empty
  end

  it ".multi_organizations? is false" do 
    expect(Authorization.new('123.123.123.123', user).multi_organizations?).not_to be
  end

  context "when user has auth 1 in org1" do
    let!(:permission) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 1) }

    it ".authlevel(org1) equals 1" do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1)).to eq(1)
    end

    it ".has_authorization? is true" do
      expect(Authorization.new('123.123.123.123', user).has_authorization?).to be
    end

    it ".multi_organizations? is false" do
      expect(Authorization.new('123.123.123.123', user).multi_organizations?).not_to be
    end
  end

  context "when user has auth 1 in org1 and 2 in org2" do
    let!(:permission1) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 1) }
    let!(:permission2) { FactoryBot.create(:permission, user: user, organization: org2, authlevel: 2) }

    it ".authlevels[org1.id] eq 1 and .authlevels[org2.id] eq 2" do
      expect(Authorization.new('123.123.123.123', user).authlevels[org1.id]).to eq(1)
      expect(Authorization.new('123.123.123.123', user).authlevels[org2.id]).to eq(2)
    end

    it ".authlevel(org1) eq 1 and .authlevel(org2) eq 2" do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1)).to eq(1)
      expect(Authorization.new('123.123.123.123', user).authlevel(org2)).to eq(2)
    end

    it ".authlevel(org1.id) eq 1" do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1.id)).to eq(1)
    end

    it ".has_authorization? is true" do 
      expect(Authorization.new('123.123.123.123', user).has_authorization?).to be
    end

    it ".multi_organizations? is true" do 
      expect(Authorization.new('123.123.123.123', user).multi_organizations?).to be
    end
  end

  # context 'when 133.133.0.0 is in network database with authlevel 20' do 
  #   let!(:net) { org1.networks.create(name: '133.133.0.0', authlevel: 20) }

  #   it ".has_authorization? is true for 133.133.133.2" do
  #     expect(Authorization.new('133.133.133.2', user).has_authorization?).to be true
  #   end

  #   it ".multi_organizations is false on 133.133.133.2" do
  #     expect(Authorization.new('133.133.133.2', user).multi_organizations).not_to be
  #   end

  #   it "gives authlevels 20 on 133.133.133.2 in org1" do
  #     expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq 20
  #   end

  #   context "when user is admin in other organization (org2) with level 30" do
  #     let!(:admin) { org2.admins.create(user: user, authlevel: 30) }

  #     it ".has_authorization? is true for 133.133.133.2" do
  #       expect(Authorization.new('133.133.133.2', user).has_authorization?).to be
  #     end

  #     it ".multi_organizations is true for 133.133.133.2" do
  #       expect(Authorization.new('133.133.133.2', user).multi_organizations).to be
  #     end

  #     it "authlevels for first org1 is 20" do
  #       expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq(20)
  #     end

  #     it "authlevels for second org2 is 30" do
  #       expect(Authorization.new('133.133.133.2', user).authlevels[org2.id]).to eq(30)
  #     end
  #   end

  #   context "when user is admin in same org1" do
  #     let!(:admin) { org1.admins.create(user: user, authlevel: 30) }

  #     it ".multi_organizations is false for 133.133.133.2" do
  #       expect(Authorization.new('133.133.133.2', user).multi_organizations).not_to be
  #     end

  #     it "authlevels for org1 is 30" do
  #       expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq(30)
  #     end
  #   end
  # end
end
end
