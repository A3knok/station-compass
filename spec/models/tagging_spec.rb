require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:route) { create(:route) }
  let(:tag) { create(:tag) }

  describe "バリデーション" do
    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        tagging = build(:tagging)
        expect(tagging).to be_valid
      end

      it "異なるルートで同じタグをつけた場合に有効であること" do
        create(:tagging, route: route, tag: tag)
        other_route = create(:route)
        tagging = build(:tagging, route: other_route, tag: tag)
        expect(tagging).to be_valid
      end

      it "同じルートで異なるタグをつけた場合に有効であること" do
        create(:tagging, route: route, tag: tag)
        other_tag = create(:tag)
        tagging = build(:tagging, route: route, tag: other_tag)
        expect(tagging).to be_valid
      end
    end

    context "異常系" do
      it "１つルートに同じタグを複数つけた場合に無効であること" do
        create(:tagging, route: route, tag: tag)
        tagging = build(:tagging, route: route, tag: tag)
        expect(tagging).to be_invalid
        expect(tagging.errors[:tag_id]).to include("はすでに使用されています")
      end

      it "routeがない場合に無効であること" do
        tagging = build(:tagging, route: nil, tag: tag)
        expect(tagging).to be_invalid
        expect(tagging.errors[:route]).to include("を入力してください")
      end

      it "tagがない場合に無効であること" do
        tagging = build(:tagging, route: route, tag: nil)
        expect(tagging).to be_invalid
        expect(tagging.errors[:tag]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:tag) }
    it { should belong_to(:route) }  
  end

  describe "Ransackの設定" do
    it "ransackable_associationsが正しく設定されていること" do
      expect(Tagging.ransackable_associations).to include("tag", "route")
    end
  end
end
