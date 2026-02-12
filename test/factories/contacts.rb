FactoryBot.define do
  factory :contact do
    sequence(:subject) { |n| "件名#{n}" }
    body { "rspec用の問合せテキストです" }

    association :user

    trait :short_body do
      body { "a" * 9 }
    end
  end
end
