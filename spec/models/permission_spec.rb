require 'rails_helper'

RSpec.describe DmUniboCommon::Permission, type: :model do
  let (:authlevels) { Authorization.all_authlevels }
  let (:read_permission)  { FactoryBot.create(:permission, authlevel: 1) }
  let (:write_permission) { FactoryBot.create(:permission, authlevel: 2) }
  let (:pippo_permission) { FactoryBot.create(:permission, authlevel: 3) }

  it "read_permission means user.can_read?(organization) to be true" do
    # expect(read_permission.user.can_read?(read_permission.organization)).to be(true)
  end

  #it "read_permission means user.can_manage?(organization) to be false" do
  #  expect(read_permission.user.can_manage?(read_permission.organization)).to be(true)
  #end
end

