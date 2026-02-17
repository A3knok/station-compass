FactoryBot.define do
  factory :exit do
    sequence(:name) { |n| "テスト出口#{n}" }
    direction { "テスト方面" }
    association :station
  end
end
