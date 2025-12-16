require "rails_helper"

RSpec.describe DmUniboCommon::LinkHelper, type: :helper do
  describe "#link_to_back" do
    it "returns indietro as text" do
      expect(helper.link_to_back("/pippo")).to match(/indietro/)
    end
  end
end
