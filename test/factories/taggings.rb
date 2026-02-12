FactoryBot.define do
  factory :tagging do
    association :tag
    association :route
  end
end
