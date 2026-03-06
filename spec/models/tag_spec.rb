require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    context "正常系" do
      it "すべてのバリデーションが機能しているか" do
        tag = Tag.new(name: "tag")
        expect(tag).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        tag = Tag.new(name: nil)
        expect(tag).to be_invalid
        expect(tag.errors[:name]).to include("を入力してください")
      end

      it "nameが空文字の場合に無効であること" do
        tag = Tag.new(name: "")
        expect(tag).to be_invalid
        expect(tag.errors[:name]).to include("を入力してください")
      end

      it "nameが重複した場合に無効であること" do
        tag1 = Tag.create(name: "category")
        tag2 = Tag.new(name: "category")
        expect(tag2).to be_invalid
        expect(tag2.errors[:name]).to include("はすでに使用されています")
      end

      it "nameにカンマが含まれる場合に無効であること" do
        tag = Tag.new(name: "tag1, tag2")
        expect(tag).to be_invalid
        expect(tag.errors[:name]).to include("にカンマを含めることはできません")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:routes).through(:taggings) }
  end

  describe "Ransackの設定" do
    it "ransackable_attributesが正しく設定されていること" do
      expect(Tag.ransackable_attributes).to include("name")
    end
  end
end
