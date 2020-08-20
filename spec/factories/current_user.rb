FactoryBot.define do
  factory :current_user, class: "DmUniboCommon::CurrentUser" do
    sequence(:id) { |n| n }
    upn  { 'nome.cognome@unibo.it' }
    name { "Nome" }
    surname { "Cognome" }
  end
end




