FactoryBot.define do
  factory :station do
    sequence(:name) { |n| "駅#{n}" }
    latitude { 35.681236 }
    longitude { 139.767125 }

    # 緯度の境界値テスト用trait
    trait :at_south_pole do
      name { "南極地点" }
      latitude { -90 }
      longitude { 0 }  
    end
    
    trait :at_north_pole do
      name { "北極地点" }
      latitude { 90 }
      longitude { 0 }
    end

    # 軽度の境界値テスト用trait
    trait :at_west_dateline do
      name { "日付変更線西駅" }
      latitude { 0 }
      longitude { -180 }
    end

    trait :at_east_dateline do
      name { "日付変更線東駅" }
      latitude { 0 }
      longitude { 180 }
    end
  end
end
