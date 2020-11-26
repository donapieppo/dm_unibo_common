require 'rails_helper'

RSpec.describe Authorization, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:org1) { FactoryBot.create(:organization) }
  let(:org2) { FactoryBot.create(:organization) }

  context 'without permissions, Authorization.new(133.133.133.2, user)' do
    it '.any? is false' do
      expect(Authorization.new('133.133.133.2', user).any?).not_to be
    end

    it '.authlevels is empty' do
      expect(Authorization.new('133.133.133.2', user).authlevels).to be_empty
    end

    it '.multi_organizations? is false' do 
      expect(Authorization.new('133.133.133.2', user).multi_organizations?).not_to be
    end
  end

  context 'when user has permission org1 with authlevel 1' do
    let!(:permission) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 1) }

    it '.authlevel(org1) == 1' do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1)).to eq(1)
    end

    it '.authlevel(org1.id) == 1' do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1.id)).to eq(1)
    end

    it '.any? is true' do
      expect(Authorization.new('123.123.123.123', user).any?).to be
    end

    it '.multi_organizations? is false' do
      expect(Authorization.new('123.123.123.123', user).multi_organizations?).not_to be
    end
  end

  context 'when user has auth 1 in org1 and 2 in org2' do
    let!(:permission1) { FactoryBot.create(:permission, user: user, organization: org1, authlevel: 1) }
    let!(:permission2) { FactoryBot.create(:permission, user: user, organization: org2, authlevel: 2) }

    it '.authlevel(org1) == 1' do
      expect(Authorization.new('123.123.123.123', user).authlevel(org1)).to eq(1)
    end

    it '.authlevel(org2) == 2' do
      expect(Authorization.new('123.123.123.123', user).authlevel(org2)).to eq(2)
    end

    it '.any? is true' do 
      expect(Authorization.new('123.123.123.123', user).any?).to be
    end

    it '.multi_organizations? is true' do 
      expect(Authorization.new('123.123.123.123', user).multi_organizations?).to be
    end
  end

  context 'when 133.133.0.0 is in permissions with authlevel 2 on org1' do 
    let!(:permission) { FactoryBot.create(:permission, user: nil, organization: org1, network: '133.133.0.0', authlevel: 2) }

    it '.any? is true for 133.133.133.2' do
      expect(Authorization.new('133.133.133.2', user).any?).to be 
    end

    it '.multi_organizations? is false on 133.133.133.2' do
      expect(Authorization.new('133.133.133.2', user).multi_organizations?).not_to be
    end

    it 'gives authlevels 20 on 133.133.133.2 in org1' do
      expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq 2
    end

    context "when user is admin in other organization (org2) with level 3" do
      let!(:permission2) { FactoryBot.create(:permission, user: user, organization: org2, authlevel: 3) }

      it '.any? is true for 133.133.133.2' do
        expect(Authorization.new('133.133.133.2', user).any?).to be
      end

      it '.multi_organizations? is true for 133.133.133.2' do
        expect(Authorization.new('133.133.133.2', user).multi_organizations?).to be
      end

      it 'authlevels for first org1 is 20' do
        expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq 2
      end

      it 'authlevels for second org2 is 30' do
        expect(Authorization.new('133.133.133.2', user).authlevels[org2.id]).to eq 3
      end
    end

    context 'when user is admin in same org1' do
      let!(:permission3) { FactoryBot.create(:permission, user: user, organization: org1, network: nil, authlevel: 3) }

      it '.multi_organizations? is false for 133.133.133.2' do
        expect(Authorization.new('133.133.133.2', user).multi_organizations?).not_to be
      end

      it 'authlevels for org1 is 3' do
        expect(Authorization.new('133.133.133.2', user).authlevels[org1.id]).to eq 3
      end
    end
  end
end
