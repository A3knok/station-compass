require 'rails_helper'

RSpec.describe Category, type: :model do  
  describe "バリデーション" do
    context "正常系" do
      it "すべてのバリデーションが機能しているか" do
        category = Category.new(name: "category")
        expect(category).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        category = Category.new(name: nil)
        expect(category).to be_invalid
        expect(category.errors[:name]).to include("を入力してください") 
      end

      it "nameが空文字の場合に無効であること" do
        category = Category.new(name: "")
        expect(category).to be_invalid
        expect(category.errors[:name]).to include("を入力してください")
      end

      it "nameが重複した場合に無効であること" do
        category1 = Category.create(name: "category")
        category2 = Category.new(name: "category")
        expect(category2).to be_invalid
        expect(category2.errors[:name]).to include("はすでに使用されています")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:taggings).dependent(:destroy) }
  end

  describe "Ransackの設定" do
    it "ransackable_attributesが正しく設定されていること" do
      expect(Category.ransackable_associations).to include("routes")
    end

    it "ransackable_attributesが正しく設定されていること" do
      expect(Category.ransackable_attributes).to include("name")
    end
  end
end
