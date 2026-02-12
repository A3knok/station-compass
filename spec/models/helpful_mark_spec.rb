require 'rails_helper'

RSpec.describe HelpfulMark, type: :model do
  describe "バリデーション" do
    let(:user) { build(:user) }
    let(:route) { build(:route) }

    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        helpful_mark = build(:helpful_mark, route: route, user: user)
        expect(helpful_mark).to be_valid
      end

      it "異なるユーザーが同じ投稿に役に立ったマークを付けた場合に有効であること" do
        create(:helpful_mark, route: route, user: user)
        other_user = create(:user)
        helpful_mark = build(:helpful_mark, route: route, user: other_user)
        expect(helpful_mark).to be_valid
      end

      it "同じユーザーが異なる投稿に役に立ったマークを付けた場合に有効であること" do
        create(:helpful_mark, route: route, user: user)
        other_route = create(:route)
        helpful_mark = build(:helpful_mark, route: other_route, user: user)
        expect(helpful_mark).to be_valid
      end
    end

    context "異常系" do
      it "1人のユーザーが同じ投稿に役に立ったマークを付けた場合に無効であること" do
        create(:helpful_mark, route: route, user: user)
        helpful_mark = build(:helpful_mark, route: route, user: user)
        expect(helpful_mark).to be_invalid
        expect(helpful_mark.errors[:user_id]).to include("はすでに使用されています")
      end

      it "routeがない場合に無効であること" do
        helpful_mark = build(:helpful_mark, route: nil, user: user)
        expect(helpful_mark).to be_invalid
        expect(helpful_mark.errors[:route]).to include("を入力してください")
      end

      it "userがない場合に無効であること" do
        helpful_mark = build(:helpful_mark, route: route, user: nil)
        expect(helpful_mark).to be_invalid
        expect(helpful_mark.errors[:user]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:route) }
  end
end
