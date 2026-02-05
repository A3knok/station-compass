require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  describe "バリデーション" do
    let(:user) = { build(:user) }

    context "正常系" do
      it "設定した全てのバリデーションが機能しているか" do
        expect(user).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        user.name = nil
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "emailがない場合に無効であること" do
        user.email = nil
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("を入力してください")
      end

      it "emailの形式が不正な場合に無効であること" do
        user.email = "invalid_email"
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("の形式が正しくありません")
      end

      it "emailが重複している場合に無効であること" do
        create(:user, email: "test@example.com")
        user.email = "test@example.com"
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("すでに使用されています")
      end

      it "新規作成時パスワードがない場合に無効であること" do
        user.password = nil
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("を入力してください")
      end

      it "パスワードが6文字未満の場合に無効であること" do
        user.password = "12345"
        user.password_confirmation = "12345"
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end

      it "パスワード(確認用)がない場合に無効であること" do
        user.password_confirmation = nil
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("を再入力してください")
      end

      it "パスワードとパスワード(確認用)が一致しない場合に無効であること" do
        user.password = "password123"
        user.password_confirmation = "defferent123"
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("パスワードの入力が一致しません")
      end

      it "一般ユーザーがゲストユーザーのメールアドレスを使用できないこと" do
        user.email = "guest@example.com"
        user.guest = false
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("は使用できません")
      end
    end
  end
end