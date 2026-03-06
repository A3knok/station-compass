FactoryBot.define do
  factory :gate do
    sequence(:name) { |n| "改札#{n}" }
    association :railway_company
    association :station
  end
end
