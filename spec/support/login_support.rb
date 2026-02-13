module LoginSupport
  # ログイン処理を行うヘルパーメソッド
  def login_as(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password123"
    click_button "ログイン"

    expect(page).to have_content("ログインしました")  # ← 追加
  end
end