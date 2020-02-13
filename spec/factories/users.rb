FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    upn  { 'pietro.donatini@unibo.it' }
    name { "Pietro" }
    surname { "Donatini" }
  end
end



