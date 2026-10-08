require "rails_helper"

RSpec.describe DmUniboCommon::FooterComponent, type: :component do
  let(:current_user) { nil }

  # it "renders the footer wrapper" do
  #   document = render_inline(described_class.new(current_user))
  #   expect(document.at_css("#footer")).to be_present
  # end

  # it "renders default privacy link when config privacy_url is nil" do
  #   allow(Rails.configuration.unibo_common).to receive(:privacy_url).and_return(nil)
  #   document = render_inline(described_class.new(current_user))
  #
  #   links = document.css("#footer a[href]")
  #   privacy_link = links.find { |link| link.text.include?("Privacy") }
  #
  #   expect(privacy_link["href"])
  #     .to eq("http://www.unibo.it/it/ateneo/privacy-e-note-legali/privacy/informative-sul-trattamento-dei-dati-personali")
  # end
  #
  # it "renders custom privacy_url from config" do
  #   allow(Rails.configuration.unibo_common).to receive(:privacy_url).and_return("https://www.example.it/privacy")
  #   document = render_inline(described_class.new(current_user))
  #
  #   links = document.css("#footer a[href]")
  #   privacy_link = links.find { |link| link.text.include?("Privacy") }
  #
  #   expect(privacy_link["href"]).to eq("https://www.example.it/privacy")
  # end
  #
  # it "renders contact mail link when contact_mail is provided" do
  #   document = render_inline(described_class.new(current_user))
  #
  #   expect(document.at_css("a[href^='mailto:']")).to be_present
  #   expect(document.at_css("a[href='mailto:test@example.com']")).to be_present
  # end

  # it "renders contacts path link when contacts_path is provided" do
  #   document = render_inline(described_class.new(current_user))
  #
  #   expect(document.at_css("a[href='/contatti']")).to be_present
  # end
  #
  # it "renders documentation link when documentation_path is provided" do
  #   document = render_inline(described_class.new(current_user, documentation_path: "/docs"))
  #
  #   expect(document.at_css("a[href='/docs']")).to be_present
  # end
  #
  # it "renders main organization name" do
  #   document = render_inline(described_class.new(current_user))
  #
  #   expect(document.at_css("strong")).to be_present
  # end
end
