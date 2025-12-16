require "rails_helper"

RSpec.describe DmUniboCommon::IconHelper, type: :helper do
  it "renders FontAwesome markup" do
    expect(helper.dm_icon("edit")).to include("fa-edit")
  end
end

