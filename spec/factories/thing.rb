FactoryBot.define do
  factory :thing do
    organization
    sequence(:name) { |n| "Thing Name#{n}" }
  end
end
