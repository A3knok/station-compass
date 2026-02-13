require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  describe "ログイン前" do
    let!(:user) { create(:user) }

    context "フォームの入力値が正常" do
      it "ログインが成功する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).to have_content("ログインしました")
        expect(current_path).to eq user_path(user)
      end
    end

    context "メールアドレスが未入力" do
      it "ログインに失敗する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).to have_content("メールアドレスまたはパスワードが正しくありません")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "パスワードが未入力" do
      it "ログインに失敗する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: ""
        click_button "ログイン"

        expect(page).to have_content("メールアドレスまたはパスワードが正しくありません")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "メールアドレスが間違っている場合" do
      it "ログインに失敗する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: "wrong_email@example.com"
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).to have_content("メールアドレスまたはパスワードが正しくありません")
        expect(current_path).to eq new_user_session_path
      end
    end

    context "パスワードが間違っている場合" do
      it "ログインに失敗する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "wrong_password"
        click_button "ログイン"

        expect(page).to have_content("メールアドレスまたはパスワードが正しくありません")
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログイン後" do
    let!(:user) { create(:user) }

    before { login_as(user) }

    context "ログアウトボタンを押した場合" do
      it "ログアウトできる" do
        visit user_path(user)
        click_link "ログアウト"

        expect(page).to have_content("ログアウトしました")
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
