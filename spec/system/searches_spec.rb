require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let!(:user) { create(:user) }

  let!(:station) { create(:station, name: "渋谷駅") }

  let!(:gate1) { create(:gate, station: station) }
  let!(:gate2) { create(:gate, station: station) }

  let!(:exit1) { create(:exit, station: station) }
  let!(:exit2) { create(:exit, station: station) }

  let!(:category1) { create(:category) }
  let!(:category2) { create(:category) }

  let!(:tag1) { create(:tag, name: "旅行") }
  let!(:tag2) { create(:tag, name: "仕事") }

  let!(:route1) { create(:route, gate: gate1, exit: exit1, category: category1) }
  let!(:route2) { create(:route, gate: gate2, exit: exit2, category: category2) }

  before do
    login_as(user)
    visit station_routes_path(station)
  end

  describe "検索機能" do
    describe "セレクトボックス検索" do
      context "改札(出発地)検索" do
        it "選択した出口のルートが表示される" do
          select gate1.name, from: "出発地"
          click_button "検索"

          expect(page).to have_content(route1.description)
          expect(page).not_to have_content(route2.description)
        end
      end

      context "出口(目的地)検索" do
        it "選択した目的地のルートが表示される" do
          select exit1.name, from: "目的地"
          click_button "検索"

          expect(page).to have_content(route1.description)
          expect(page).not_to have_content(route2.description)
        end
      end
    end

    describe "チェックボックス検索" do
      context "1つのカテゴリーを選択した場合" do
        it "そのカテゴリーのルートのみ表示される" do
          check category1.name
          click_button "検索"

          expect(page).to have_content(route1.description)
          expect(page).not_to have_content(route2.description)
        end
      end

      context "複数のカテゴリーを選択した場合" do
        it "選択したカテゴリーのルートが表示される" do
          check category1.name
          check category2.name
          click_button "検索"

          expect(page).to have_content(route1.description)
          expect(page).to have_content(route2.description)
        end
      end
    end

    describe "オートコンプリート検索" do
      it "タグを入力して検索できる", js: true do
        sleep 1

        find("#q_tags_name_in", visible: :all).select("旅")
        click_button "検索"

        expect(page).to have_content(route1.description)
        expect(page).not_to have_content(route2.description)
      end
    end

    describe "複合検索" do
      it "出口とカテゴリーを組み合わせて検索できる", js: true do
        select exit1.name, from: "目的地"
        check category1.name
        click_button "検索"

        expect(page).to have_content(route1.description)
        expect(page).not_to have_content(route2.description)
      end

      it "出口とカテゴリーが一致しない場合は結果が表示されない", js: true do
        select exit1.name, from: "目的地"
        check category2.name
        click_button "検索"

        expect(page).not_to have_content(route1.description)
        expect(page).not_to have_content(route2.description)

        expect(page).to have_content("まだルートが投稿されていません")
      end
    end
  end
end
