require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { FactoryBot.create(:organization) }

  it "has many permissions" do
    expect(subject).to respond_to(:permissions) 
  end
end
