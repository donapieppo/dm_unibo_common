require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:thing) { FactoryBot.create(:thing, user_id: user.id) }

  CESIA_UPN = ['uno@uno.com', 'nome.cognome2222@unibo.it']

  it '.is_cesia? is false if CESIA does not include user.upn' do
    expect(user.is_cesia?).not_to be
  end

  it '.is_cesia? is true if CESIA does include user.upn' do
    user.upn = 'nome.cognome2222@unibo.it'
    expect(user.is_cesia?).to be
  end

  it '.owns?(thing) is true if thing.user_id == user.id' do
    expect(user.owns?(thing)).to be
  end

  it '.owns?(thing) is false if thing.user_id != user.id' do
    thing.user_id = FactoryBot.create(:user, upn: 'a@b.com').id
    expect(user.owns?(thing)).not_to be
  end

  it '.owns?(thing) is true if thing.user_id != user.id but user is cesia' do
    user2 = FactoryBot.create(:user, upn: 'nome.cognome2222@unibo.it')
    thing.user_id = user2.id
    expect(user2.owns?(thing)).to be
  end

  it ".owns(book) with user has_and_belongs_to_many books" do
  end
end
