require 'rails_helper'

RSpec.describe "RouteRankings", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { create(:user) }

  let!(:station) { create(:station) }
  let!(:exit) { create(:exit, station: station) }
  let!(:route1) { create(:route, exit: exit) }
  let!(:route2) { create(:route, exit: exit) }
  let!(:route3) { create(:route, exit: exit) }

  before { login_as(user) }

  describe "ランキング表示" do
    context "役に立ったの数がルートごとに異なる場合" do
      before do
        create_list(:helpful_mark, 3, route: route1)
        create_list(:helpful_mark, 2, route: route2)
        create_list(:helpful_mark, 1, route: route3)

        visit station_ranks_path(station)
      end

      it "役に立った数が多い順に表示される" do
        counts = page.all(".ranking-item").map do |row|
          row.all("td")[2].text.to_i # ランキングページの3番目のtd（評価数）
        end

        expect(counts).to eq([ 3, 2, 1 ])
      end

      it "各ルートの役に立った数が正しく表示される" do
        within(first(".ranking-item")) do
          expect(page).to have_content("3")
        end

        within(all('.ranking-item')[1]) do
          expect(page).to have_content("2")
        end

        within(all('.ranking-item')[2]) do
          expect(page).to have_content("1")
        end
      end
    end

    context "役に立ったの数が複数ルートで同じ場合" do
      before do
        create_list(:helpful_mark, 2, route: route1)
        create_list(:helpful_mark, 2, route: route2)

        visit station_ranks_path(station)
      end

      it "作成日時が新しい順に表示される" do
        route_ids = page.all(".ranking-item").map do |row|
          row["data-route-id"]
        end

        expect(route_ids[0..1]).to eq([ route2.id, route1.id ])
      end
    end
  end
end
