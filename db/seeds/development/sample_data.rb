# 開発環境でデータリセット処理
if Rails.env.development?
  puts "既存データを削除中..."

  Route.destroy_all # 子
  Gate.destroy_all # 親(gate_idをroutesが参照)
  Exit.destroy_all # 親(exit_idをroutesが参照)
  Station.destroy_all # 親(station_idをgates, exitsが参照)
  RailwayCompany.destroy_all # 親(railway_company_idをgatesが参照)
  User.destroy_all # 親(user_idをroutesが参照)

  puts "データリセット完了"
  puts "サンプルデータ作成中..."
end

# テスト用ユーザー作成
users = [
  User.create!(name: "テストユーザー1", email: "test1@example.com", password: "password", password_confirmation: "password"),
  User.create!(name: "テストユーザー2", email: "test2@example.com", password: "password", password_confirmation: "password")
]

# テスト用鉄道会社作成
railway_companies_data = [
  { name: "テスト鉄道A" },
  { name: "テスト鉄道B" }
]

railway_companies = railway_companies_data.map do |company_data|
  # RailwayCompanyオブジェクトの配列が渡される
  # RailwayCompany.find_or_create_by!(name: "テスト鉄道2")みたく渡される
  RailwayCompany.find_or_create_by!(company_data)
end

# テスト用駅作成
station = Station.find_or_create_by!(name: 'テスト駅')

# テスト用出口作成
exits = [
  { name: 'テスト出口1', direction: 'テスト方面1' },
  { name: 'テスト出口2', direction: 'テスト方面2' }
]

exits.each do |exit|
  station.exits.find_or_create_by!(exit)
end

# テスト用改札作成
railway_companies.each_with_index do |company, index|
  station.gates.find_or_create_by!(name: "テスト改札#{index + 1}") do |gate|
    gate.railway_company = company
  end
end

puts "テストデータ作成完了"
puts "ユーザー： #{User.count}件"
puts "鉄道会社: #{RailwayCompany.count}件"
puts "駅: #{Station.count}件"
puts "改札: #{Gate.count}件"
puts "出口: #{Exit.count}件"
