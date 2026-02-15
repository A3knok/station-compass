require 'rails_helper'

RSpec.describe "Routes", type: :system do
  let!(:station) { create(:station) }
  let!(:railway_company) { create(:railway_company) }
  let!(:gate) { create(:gate, station: station, railway_company: railway_company) }
  let!(:exit) { create(:exit, station: station) }
  let!(:user) { create(:user) }
  let!(:route) { create(:route, user: user, gate: gate) }

  describe "ログイン前" do
    context "ルート新規作成画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit new_route_path
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ルート編集画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit edit_route_path(route)
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end
    
    context "ルート一覧画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit station_routes_path(station)
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ルート詳細画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit route_path(route)
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ゲストログイン中" do
    let!(:guest_user) { create(:user, guest: true) }

    before { login_as(guest_user) }

    context "ルート新規作成画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit new_route_path
        expect(page).to have_content("ゲストユーザーはこの操作を実行できません")
        expect(current_path).to eq stations_path
      end
    end

    context "ルート編集画面にアクセスした場合" do
      it "アクセス失敗する" do
        visit edit_route_path(route)
        expect(page).to have_content("ゲストユーザーはこの操作を実行できません")
        expect(current_path).to eq stations_path
      end
    end
    
    context "ルート一覧画面にアクセスした場合" do
      it "ルート一覧が表示される" do
        visit station_routes_path(station)
        expect(page).to have_content(route.description)
        expect(current_path).to eq station_routes_path(station)
      end
    end

    context "ルート詳細画面にアクセスした場合" do
      it "ルートの詳細情報が表示される" do
        visit route_path(route)
        expect(page).to have_content(route.description)
        expect(current_path).to eq route_path(route)
      end
    end
  end

  describe "登録済みユーザーでログイン中" do
    before { login_as(user) }

    describe "ルート新規投稿" do
      context "正常系" do
        it "フォームの入力値が正常の場合投稿成功する" do
          visit new_route_path
          select station.name, from: "駅名"
          select railway_company.name, from: "鉄道会社"
          select gate.name, from: "出発地"
          select exit.name, from: "目的地"
          fill_in "ルート詳細", with: "テストルート詳細(10文字以上)"
          fill_in "所要時間(分)", with: 5
          click_button "作成"

          expect(page).to have_content("投稿ありがとうございます!")
          expect(current_path).to eq route_path(Route.last)
        end
      end

      context "異常系" do
        it "ルート詳細が空の場合、投稿に失敗する" do
          visit new_route_path
          select station.name, from: "駅名"
          select railway_company.name, from: "鉄道会社"
          select gate.name, from: "出発地"
          select exit.name, from: "目的地"
          fill_in "ルート詳細", with: ""
          fill_in "所要時間(分)", with: 5
          click_button "作成"

          expect(page).to have_content("ルート投稿に失敗しました")
          expect(current_path).to eq new_route_path
        end
      end
    end

    describe "ルート編集" do
      context "正常系" do
        it "ルート編集できる" do
          visit edit_route_path(route)
          fill_in "ルート詳細", with: "ルート編集正常系テスト"
          click_button "更新"

          expect(page).to have_content("ルートを更新しました")
          expect(current_path).to eq route_path(route)
        end
      end

      context "異常系" do
        it "ルート詳細が空の場合、更新に失敗する" do
          visit edit_route_path(route)
          fill_in "ルート詳細", with: ""
          click_button "更新"

          expect(page).to have_content("ルート更新に失敗しました")
          expect(current_path).to eq edit_route_path(route)
        end

        it "所要時間が未入力の場合、更新に失敗する" do
          visit edit_route_path(route)
          fill_in "所要時間(分)", with: ""
          click_button "更新"

          expect(page).to have_content("ルート更新に失敗しました")
          expect(current_path).to eq edit_route_path(route)
        end
      end
    end
  end
end
