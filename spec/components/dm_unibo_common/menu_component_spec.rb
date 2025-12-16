require "rails_helper"

RSpec.describe DmUniboCommon::MenuComponent, type: :component do
  let(:organization) { FactoryBot.build(:organization, description: "Org description") }

  it "renders login icon" do
    render_inline(described_class.new(nil, current_organization: organization))

    expect(rendered_content).to include("fa-sign-in")
  end
end
