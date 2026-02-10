FactoryBot.define do
  factory :route do
    description { "rspec用のテストルートです" }
    estimated_time { 5 }
    helpful_marks_count { 0 }
    images { [] }

    association :user
    association :gate
    association :exit
    association :category

    trait :short_description do
      description { "a" * 9 }
    end

    trait :long_description do
      description { "a" * 1001 }
    end
  end
end
