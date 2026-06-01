require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { FactoryBot.create(:organization) }

  it "has many permissions" do
    expect(subject).to respond_to(:permissions) 
  end

  it "allows code with letters, numbers, dots, underscores and hyphens" do
    organization = FactoryBot.build(:organization, code: "ABC_12.foo-bar")
    expect(organization).to be_valid
  end

  it "does not allow code with spaces, path separators or punctuation at the edges" do
    organization = FactoryBot.build(:organization, code: "ABC 12/foo")
    expect(organization).not_to be_valid

    organization.code = ".ABC12"
    expect(organization).not_to be_valid

    organization.code = "ABC12-"
    expect(organization).not_to be_valid
  end
end
