require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    let(:user) { build(:user) }

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
        expect(user.errors[:email]).to include("はすでに使用されています")
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
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end

      it "一般ユーザーがゲストユーザーのメールアドレスを使用できないこと" do
        user.email = "guest@example.com"
        user.guest = false
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("このメールアドレスは使用できません")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:routes).dependent(:destroy) }
    it { should have_many(:helpful_marks).dependent(:destroy) }
    it { should have_many(:helpful_routes).through(:helpful_marks).source(:route) }
    it { should have_many(:contacts).dependent(:destroy) }
  end

  describe "ゲストユーザー機能" do
    describe ".guest_user" do 
      context "初回呼び出し時" do
        it "ゲストユーザーを作成できること" do
          expect { User.guest_user }.to change(User, :count).by(1)
        end

        it "作成されたゲストユーザーが正しい属性を持つこと" do
          guest = User.guest_user
          expect(guest.email).to eq("guest@example.com")
          expect(guest.name).to eq("ゲストユーザー")
          expect(guest.guest).to be true
          expect(guest).to be_persisted
        end

        it "パスワードがランダム生成されること" do
          guest = User.guest_user
          expect(guest.encrypted_password).to be_present
        end
      end

      context "2回目以降の呼び出し時" do
        it "既存のゲストユーザーを返すこと" do
          guest1 = User.guest_user
          expect{ guest1 }.not_to change(User, :count)
        end

        it "同じユーザーインスタンスを返すこと" do
          guest1 = User.guest_user
          guest2 = User.guest_user
          expect(guest1.id).to eq(guest2.id)
        end
      end
    end

    describe "#guest?" do
      context "ゲストユーザーの場合" do
        it "trueを返すこと" do
          guest = User.guest_user
          expect(guest.guest?).to be true
        end
      end

      context "一般ユーザーの場合" do
        it "falseを返すこと" do
          user = create(:user)
          expect(user.guest?).to be false 
        end
      end
    end
  end

  describe "OAuth認証機能" do
    describe "#oauth_user?" do
      context "providerとuidが存在する場合" do
        it "trueを返すこと" do
          user = create(:user, provider: "google_oauth2", uid: "123456789")
          expect(user.oauth_user?).to be true
        end
      end

      context "providerまたはuidが存在しない場合" do
        it "falseを返すこと" do
          user = create(:user, provider: nil, uid: nil)
          expect(user.oauth_user?).to be false
        end
      end
    end

    describe ".from_omniauth" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "123456789",
          info: {
            email: "oauth_user@example.com",
            name: "OAuth User"
          }
        )
      end

      context "初回認証時" do
        it "新しいユーザーを作成すること" do
          expect {
            User.from_omniauth(auth_hash)
        }.to change(User, :count).by(1)
        end

        it "作成されたユーザーが正しい属性をもつこと" do
          user = User.from_omniauth(auth_hash)
          expect(user.name).to eq("OAuth User")
          expect(user.email).to eq("oauth_user@example.com")
          expect(user.provider).to eq("google_oauth2")
          expect(user.uid).to eq("123456789")
          expect(user.encrypted_password).to be_present
        end
      end

      context "2回目認証時" do
        it "既存のユーザーを返すこと" do
          user1 = User.from_omniauth(auth_hash)
          expect {
            User.from_omniauth(auth_hash)
        }.not_to change(User, :count)
        end

        it "同じユーザーインスタンスを返すこと" do
          user1 = User.from_omniauth(auth_hash)
          user2 = User.from_omniauth(auth_hash)
          expect(user1.id).to eq(user2.id)
        end
      end
    end
  end

  describe "パスワード更新時の挙動" do
    let(:user) { create(:user) }

    context "パスワードを更新しない場合" do
      it "パスワードのバリデーションがスキップされること" do
        user.name = "new_name"
        expect(user).to be_valid
      end
    end
  end
end