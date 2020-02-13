require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { FactoryBot.create(:organization) }

  it "first test" do
    p subject
  end
end
