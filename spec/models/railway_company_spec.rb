require 'rails_helper'

RSpec.describe RailwayCompany, type: :model do
  describe "バリデーション" do
    context "正常系" do
      it "すべてのバリデーションが機能しているか" do
        railway_company = RailwayCompany.new(name: "テスト鉄道")
        expect(railway_company).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        railway_company = RailwayCompany.new(name: nil)
        expect(railway_company).to be_invalid
        expect(railway_company.errors[:name]).to include("を入力してください")
      end

      it "nameが空文字の場合に無効であること" do
        railway_company = RailwayCompany.new(name: "")
        expect(railway_company).to be_invalid
        expect(railway_company.errors[:name]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:gates).dependent(:destroy) }
    it { should have_many(:stations).through(:gates) }
  end
end
