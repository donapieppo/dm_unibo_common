require "rails_helper"

RSpec.describe DmUniboCommon::ModalComponent, type: :component do
  it "renders the page title and content when not in modal mode" do
    document = render_inline(described_class.new(title: "Edit organization", modal_page: false)) do
      "FORM CONTENT"
    end

    expect(document.at_css("h1")&.text).to eq("Edit organization")
    expect(rendered_content).to include("FORM CONTENT")
    expect(document.at_css("turbo-frame#modal")).to be_nil
  end

  it "renders the turbo modal shell when in modal mode" do
    document = render_inline(described_class.new(title: "Edit organization", modal_page: true)) do
      "FORM CONTENT"
    end

    expect(document.at_css("turbo-frame#modal")).to be_present
    expect(rendered_content).to include("FORM CONTENT")
    expect(document.at_css('[role="dialog"][aria-modal="true"][aria-labelledby="modal_title"]')).to be_present
    expect(document.at_css("h2#modal_title")&.text).to eq("Edit organization")
    expect(document.at_css('button[type="button"]')&.text).to eq("Chiudi")
    expect(document.at_css("h1")).to be_nil
  end
end
