require 'rails_helper'

RSpec.describe Exit, type: :model do
  describe "バリデーション" do
    let(:exit) { build(:exit) }

    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        expect(exit).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        exit = build(:exit, name: nil)
        expect(exit).to be_invalid
        expect(exit.errors[:name]).to include("を入力してください")
      end

      it "nameが空文字の場合に無効であること" do
        exit = build(:exit, name: "")
        expect(exit).to be_invalid
        expect(exit.errors[:name]).to include("を入力してください")
      end

      it "directionがない場合に無効であること" do
        exit = build(:exit, direction: nil)
        expect(exit).to be_invalid
        expect(exit.errors[:direction]).to include("を入力してください")
      end

      it "directionが空文字の場合に無効であること" do
        exit = build(:exit, direction: "")
        expect(exit).to be_invalid
        expect(exit.errors[:direction]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:routes).dependent(:destroy) }
    it { should belong_to(:station) }
  end

  describe "Ransackの設定" do
    it "ransackable_attributesが正しく設定されていること" do
      expect(Exit.ransackable_attributes).to include("id", "name")
    end
  end

  describe "インスタンスメソッド" do
    describe "#display_name" do
      it "nameとdirectionを組み合わせた文字列を返すこと" do
        exit = build(:exit)
        expect(exit.display_name).to eq "#{exit.name} (#{exit.direction})"
      end
    end
  end
end
