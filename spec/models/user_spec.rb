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

      
    end
  end
end
