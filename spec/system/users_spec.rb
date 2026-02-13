require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ログイン前" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザー新規登録が成功する" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: "test_user@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード(確認用)", with: "password"
          click_button "登録"
          
          expect(page).to have_content("ユーザー登録が完了しました")

          created_user = User.last
          expect(current_path).to eq user_path(created_user)
        end
      end

      context "メールアドレスが未入力の場合" do
        it "ユーザー新規登録が失敗する" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password"
          fill_in "パスワード(確認用)", with: "password"
          click_button "登録"
          
          expect(page).to have_content("メールアドレスを入力してください")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "登録済みのメールアドレスを入力した場合" do
        it "ユーザー新規登録に失敗する" do
          other_user = create(:user)
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: other_user.email
          fill_in "パスワード", with: "password"
          fill_in "パスワード(確認用)", with: "password"
          click_button "登録"

          expect(page).to have_content("メールアドレスはすでに使用されています")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "パスワードが未入力の場合" do
        it "ユーザー新規登録に失敗する" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: "test_user@example.com"
          fill_in "パスワード", with: ""
          fill_in "パスワード(確認用)", with: ""
          click_button "登録"
          
          expect(page).to have_content("パスワードを入力してください")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "パスワードとパスワード(確認用)が一致しない場合" do
        it "ユーザー新規登録に失敗する" do
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: "test_user@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード(確認用)", with: "password123"
          click_button "登録"
          
          expect(page).to have_content("パスワード(確認用)とパスワードの入力が一致しません")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "ゲストユーザーのメールアドレスで登録しようとした場合" do
        it "ユーザー新規登録が失敗する" do
          User.guest_user
          
          visit new_user_registration_path
          fill_in "ユーザー名", with: "テストユーザー"
          fill_in "メールアドレス", with: "guest@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード(確認用)", with: "password"
          click_button "登録"
          
          expect(page).to have_content("メールアドレスはすでに使用されています")
          expect(current_path).to eq new_user_registration_path
        end
      end
    end

    describe "パスワードリセット" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      context "登録済みのメールアドレスを入力した場合" do
        it "パスワードリセットメールが送信される" do
          created_user = create(:user)
          visit new_user_password_path
          fill_in "メールアドレス", with: created_user.email
          click_button "送信"

          expect(page).to have_content("パスワードリセット手順を送信しました", wait: 10)
          expect(current_path).to eq new_user_session_path

          expect(ActionMailer::Base.deliveries.size).to eq 1
          expect(ActionMailer::Base.deliveries.last.to).to eq [created_user.email]
        end
      end
    end
  end

  describe "ログイン後" do
    let!(:user) { create(:user) }

    before { login_as(user) }

    describe "アカウント情報編集" do
      context "入力値が正常" do
        it "アカウント情報を編集できる" do
          visit edit_user_registration_path
          fill_in "メールアドレス", with: "updated@example.com"
          fill_in "現在のパスワード", with: "password123"
          click_button "更新"

          expect(page).to have_content("アカウント情報を変更しました")
        end  
      end

      context "現在のパスワードが未入力の場合" do
        it "アカウント情報の更新に失敗する" do
          visit edit_user_registration_path
          fill_in "メールアドレス", with: "updated@example.com"
          fill_in "現在のパスワード", with: ""
          click_button "更新"

          expect(page).to have_content("現在のパスワードを入力してください")
        end
      end

      context "現在のパスワードが間違っている場合" do
        it "アカウント情報の更新に失敗する" do
          visit edit_user_registration_path
          fill_in "メールアドレス", with: "updated@example.com"
          fill_in "現在のパスワード", with: "wrong_password"
          click_button "更新"

          expect(page).to have_content("現在のパスワードが正しくありません")
        end
      end
    end
  end
end
