require 'rails_helper'

RSpec.describe Route, type: :model do
  describe "バリデーション" do
    let(:route) { build_stubbed(:route) }

    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        expect(route).to be_valid
      end
    end

    context "異常系" do
      it "gateがない場合に無効であること" do
        route = build(:route, gate_id: nil)
        expect(route).to be_invalid
        expect(route.errors[:gate_id]).to include("を選択してください")
      end

      it "exitがない場合に無効であること" do
        route = build(:route, exit_id: nil)
        expect(route).to be_invalid
        expect(route.errors[:exit_id]).to include("を選択してください")
      end

      it "descriptionがない場合に無効であること" do
        route = build(:route, description: nil)
        expect(route).to be_invalid
        expect(route.errors[:description]).to include("を入力してください")
      end

      it "descriptionが空文字の場合に無効であること" do
        route = build(:route, description: "")
        expect(route).to be_invalid
        expect(route.errors[:description]).to include("を入力してください")
      end

      it "descriptionが10文字未満の場合に無効であること" do
        route = build(:route, :short_description)
        expect(route).to be_invalid
        expect(route.errors[:description]).to include("は10文字以上で入力してください")
      end

      it "descriptionが1000文字を超える場合に無効であること" do
        route = build(:route, :long_description)
        expect(route).to be_invalid
        expect(route.errors[:description]).to include("は1000文字以内で入力してください")
      end

      it "estimated_timeが無い場合に無効であること" do
        route = build(:route, estimated_time: nil)
        expect(route).to be_invalid
        expect(route.errors[:estimated_time]).to include("を入力してください")
      end

      it "estimated_timeが空文字の場合に無効であること" do
        route = build(:route, estimated_time: "")
        expect(route).to be_invalid
        expect(route.errors[:estimated_time]).to include("を入力してください")
      end

      it "estimated_timeが負の数の場合に無効であること" do
        route = build(:route, estimated_time: -1)
        expect(route).to be_invalid
        expect(route.errors[:estimated_time]).to include("は0より大きい値にしてください")
      end

      it "estimated_timeが0分の場合に無効であること" do
        route = build(:route, estimated_time: 0)
        expect(route).to be_invalid
        expect(route.errors[:estimated_time]).to include("は0より大きい値にしてください")
      end
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:gate).required }
    it { should belong_to(:exit).required }
    it { should belong_to(:category).optional(true) }
    it { should have_one(:station).through(:gate) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
    it { should have_many(:helpful_marks).dependent(:destroy) }
  end

  describe "Ransackの設定" do
    it "ransackable_attributesが正しく設定されていること" do
      expect(Route.ransackable_attributes).to include("exit_id", "gate_id", "category_id")
    end

    it "ransackable_associationsが正しく設定されていること" do
      expect(Route.ransackable_associations).to include("gate", "exit", "tags", "taggings", "station", "category")
    end
  end

  describe "#tag_names=" do
    let(:route) { create(:route) }

    context "正常系" do
      it "カンマ区切りのタグ名を設定できること" do
        route.tag_names = "tag1, tag2, tag3"
        expect(route.tags.pluck(:name)).to match_array([ "tag1", "tag2", "tag3" ])
      end

      it "タグ名が小文字に変換されること" do
        route.tag_names = "TAG1, Tag2, Tag3"
        expect(route.tags.pluck(:name)).to match_array([ "tag1", "tag2", "tag3" ])
      end

      it "タグの重複が排除されること" do
        route.tag_names = "tag1, tag2, tag3, tag3"
        expect(route.tags.pluck(:name)).to match_array([ "tag1", "tag2", "tag3" ])
      end

      it "既存のタグがクリアされること" do
        tag1 = create(:tag, name: "old_tag")
        route.tags << tag1
        route.tag_names = "new_tag"
        expect(route.tags.pluck(:name)).to eq([ "new_tag" ])
      end

      it "前後の空白が削除されること" do
        route.tag_names = " tag1 , tag2 "
        expect(route.tags.pluck(:name)).to match_array([ "tag1", "tag2" ])
      end
    end

    context "異常系" do
      it "nilを渡したときにエラーが起きないこと" do
        expect { route.tag_names = nil }.not_to raise_error
      end

      it "空文字を渡したときにエラーが起きないこと" do
        expect { route.tag_names = "" }.not_to raise_error
      end

      it "空白のタグが作成されないこと" do
        route.tag_names = "tag1, , tag2"
        expect(route.tags.pluck(:name)).to match_array([ "tag1", "tag2" ])
      end

      it "空白のみの文字列を渡したときにタグが作成されないこと" do
        route.tag_names = " "
        expect(route.tags.count).to eq(0)
      end
    end
  end

  describe "#tag_names" do
    context "正常系" do
      let(:route) { create(:route) }

      it "タグ名がカンマ区切りで返されること" do
        tag1 = create(:tag, name: "tag1")
        tag2 = create(:tag, name: "tag2")
        route.tags << [ tag1, tag2 ]
        expect(route.tag_names).to eq("tag1,tag2")
      end

      it "タグレコードが存在しない場合に空文字が返されること" do
        expect(route.tag_names).to eq("")
      end
    end
  end

  describe "#helpful_by?" do
    context "正常系" do
      let(:route) { create(:route) }
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      it "ユーザーが役に立ったマークを押している場合にtrueを返すこと" do
        create(:helpful_mark, route: route, user: user)
        expect(route.helpful_by?(user)).to be true
      end

      it "ユーザーが役に立ったマークを押していない場合にfalseを返すこと" do
        expect(route.helpful_by?(user)).to be false
      end

      it "他のユーザーが役に立ったマークを押している場合でもfalseを返すこと" do
        create(:helpful_mark, route: route, user: other_user)
        expect(route.helpful_by?(user)).to be false
      end
    end
  end

  describe "#helpful_count" do
    context "正常系" do
      let(:route) { create(:route) }
      let(:other_route) { create(:route) }
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      it "役に立ったマークが0件の場合に0を返すこと" do
        expect(route.helpful_count).to eq(0)
      end

      it "役に立ったマークが複数件の場合に正しい数を返すこと" do
        create(:helpful_mark, route: route, user: user1)
        create(:helpful_mark, route: route, user: user2)
        route.reload
        expect(route.helpful_count).to eq(2)
      end

      it "他のrouteの役に立ったマークは数えないこと" do
        create(:helpful_mark, route: route, user: user1)
        create(:helpful_mark, route: other_route, user: user2)
        route.reload
        expect(route.helpful_count).to eq(1)
      end

      it "役に立ったマークを削除するとカウントが減ること" do
        helpful_mark1 = create(:helpful_mark, route: route, user: user1)
        helpful_mark2 = create(:helpful_mark, route: route, user: user2)
        route.reload
        expect(route.helpful_count).to eq(2)

        helpful_mark1.destroy
        route.reload
        expect(route.helpful_count).to eq(1)
      end

      it "すべての役に立ったマークを削除するとカウントが0になること" do
        helpful_mark1 = create(:helpful_mark, route: route, user: user1)
        helpful_mark2 = create(:helpful_mark, route: route, user: user2)
        route.reload

        helpful_mark1.destroy
        helpful_mark2.destroy
        route.reload
        expect(route.helpful_count).to eq(0)
      end
    end
  end
end
