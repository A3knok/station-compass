puts "本番環境用データ作成中..."

# カテゴリーの作成
categories_data = [
  { name: "旅行" },
  { name: "仕事" },
  { name: "日常" }
]

categories = categories_data.each do |category|
  Category.find_or_create_by!(category)
end

railway_companies_data = [
  { name: "JR東日本" },
  { name: "東京メトロ / 東急電鉄" },
  { name: "京王電鉄" }
]

railway_companies = railway_companies_data.map do |company_data|
  RailwayCompany.find_or_create_by!(company_data)
end

stations_data = [
  { name: "渋谷駅" }
]

stations = stations_data.map do |station_data|
  Station.find_or_create_by!(station_data)
end

shibuya_station = Station.find_by(name: "渋谷駅")

if shibuya_station
  shibuya_gates = [
    { name: "ハチ公改札(JR)", railway_company: railway_companies[0] },
    { name: "中央改札", railway_company: railway_companies[0] },
    { name: "南改札", railway_company: railway_companies[0] },
    { name: "新南改札", railway_company: railway_companies[0] },
    { name: "ハチ公改札(メトロ)", railway_company: railway_companies[1] },
    { name: "渋谷ヒカリエ1改札", railway_company: railway_companies[1] },
    { name: "渋谷ヒカリエ2改札", railway_company: railway_companies[1] },
    { name: "スクランブルスクエア方面改札", railway_company: railway_companies[1] },
    { name: "宮益坂中央改札", railway_company: railway_companies[1] },
    { name: "宮益坂東改札", railway_company: railway_companies[1] },
    { name: "中央口改札", railway_company: railway_companies[2] }
  ]
end

shibuya_gates.each do |gate_data|
  # 検索または作成
  shibuya_station.gates.find_or_create_by!(
    name: gate_data[:name],
    railway_company: gate_data[:railway_company]
  )
end

shibuya_exits = [
  { name: "ハチ公口", direction: "渋谷PARCO方面" },
  { name: "西口", direction: "渋谷フラスク方面" },
  { name: "東口", direction: "渋谷ヒカリエ方面" },
  { name: "新南口", direction: "渋谷サクラステージ方面" },
  { name: "A2", direction: "渋谷109方面" },
  { name: "A8", direction: "渋谷センター街方面" },
  { name: "B1", direction: "宮下パーク方面" },
  { name: "B5", direction: "渋谷ヒカリエ方面" },
  { name: "C2", direction: "渋谷ストリーム方面" }
]

shibuya_exits.each do |exit_data|
  shibuya_station.exits.find_or_create_by!(exit_data)
end
