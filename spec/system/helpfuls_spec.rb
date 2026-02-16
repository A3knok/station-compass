require 'rails_helper'

RSpec.describe "Helpfuls", type: :system do
  let!(:user) { create(:user) }
  let!(:route) { create(:route) }

  before { login_as(user) }

  describe "役に立った機能" do
    context "まだ役にたったを押していない状態" do
      before do
        visit route_path(route)
      end

      it "役に立ったボタンが表示される" do
        expect(page).to have_css("i.fa-regular.fa-heart")
      end

      it "役に立ったのカウントが０と表示される" do
        expect(page).to have_content("0")
      end

      it "役に立ったボタンを押すと登録される" do
        expect {
          find(".btn-helpful").click
          expect(page).to have_css("i.fa-solid.fa-heart")
        }.to change(HelpfulMark, :count).by(1)
      end

      it "役に立ったの数が1件に増える" do
        find(".btn-helpful").click
        within(".btn-helpful") do
          expect(page).to have_content("1")
        end
      end

      it "塗りつぶしアイコンが表示される" do
        find(".btn-helpful").click
        expect(page).to have_css("i.fa-solid.fa-heart")
      end
    end

    context "すでに役に立ったしている状態" do
      before do
        create(:helpful_mark, user: user, route: route)
        visit route_path(route)
      end

      it "役に立ったボタンを押すと削除される" do
        expect {
            find(".btn-helpful").click
            expect(page).to have_css("i.fa-regular.fa-heart")
          }.to change(HelpfulMark, :count).by(-1)
      end

      it "役に立ったの数が0件に減る" do
        find(".btn-helpful").click
        within(".btn-helpful") do
          expect(page).to have_content("0")
        end
      end

      it "塗りつぶされていないアイコンが表示される" do
          find(".btn-helpful").click
          expect(page).to have_css("i.fa-regular.fa-heart")
      end
    end

    context "複数ユーザーの役に立った" do
      let!(:other_user) { create(:user) }

      before do
        create(:helpful_mark, user: other_user, route: route)
        visit route_path(route)
      end

      it "他のユーザーの役に立ったがカウントされている" do
        within(".btn-helpful") do
          expect(page).to have_content("1")
        end
      end

      it "自分も役に立ったを追加できる" do
        find(".btn-helpful").click
        within(".btn-helpful") do
          expect(page).to have_content("2")
        end
      end
    end
  end  
end
