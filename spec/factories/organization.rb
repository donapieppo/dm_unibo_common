FactoryBot.define do
  factory :organization do 
    sequence(:code) { |n| "A.CodeO#{n}" }
    sequence(:name) { |n| "Organization Name#{n}" }
    description     { "Organization SpecTest" }
  end
end



