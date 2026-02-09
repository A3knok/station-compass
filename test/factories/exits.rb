FactoryBot.define do
  factory :exit do
    name { "テスト出口" }
    direction { "テスト方面" }
    association :station
  end
end
