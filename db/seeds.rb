# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "#{Rails.env}環境のseedデータを読み込み中..."

case Rails.env
when 'development'
  puts "開発環境用のテストデータを読み込み中..."
  load Rails.root.join('db', 'seeds', 'production', 'real_data.rb')
when 'production'
  puts "本番環境用のテストデータを読み込み中..."
  load Rails.root.join('db', 'seeds', 'production', 'real_data.rb')
end
