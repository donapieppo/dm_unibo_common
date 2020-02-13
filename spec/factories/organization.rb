FactoryBot.define do
  factory :organization do 
    sequence(:name) { |n| "A.SpecO#{n}" }
    description     { "SpecTest" }
  end
end



