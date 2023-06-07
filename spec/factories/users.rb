FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    upn { "nome.cognome@unibo.it" }
    name { "Nome" }
    surname { "Cognome" }
  end
end
