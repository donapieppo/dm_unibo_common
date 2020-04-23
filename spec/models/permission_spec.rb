require 'rails_helper'

RSpec.describe DmUniboCommon::Permission, type: :model do
  let (:read_permission)  { FactoryBot.create(:permission, authlevel: DmUniboCommon::Authorization::TO_READ) }
  let (:write_permission) { FactoryBot.create(:permission, authlevel: DmUniboCommon::Authorization::TO_WRITE) }

  # NO 
  # depends on session/ip/astral week
  # it "read_permission means user.can_read?(organization) to be true" do
  
  #it "read_permission means user.can_read?(organization) to be true" do
  #  expect(read_permission.user.can_read?(read_permission.organization)).to be(true)
  #end

  #it "read_permission means user.can_manage?(organization) to be false" do
  #  expect(read_permission.user.can_manage?(read_permission.organization)).to be(true)
  #end
end

