FactoryBot.define do
  factory :railway_company do
    sequence(:name) { |n| "鉄道会社#{n}" }
  end
end
