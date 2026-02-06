require 'rails_helper'

RSpec.describe Station, type: :model do
  describe "バリデーション" do
    let(:station) { build{:station} }

    context "正常系" do
      it "設定した全てのバリデーションが機能しているか" do
        expect(station).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        station.name = nil
        expect(station).to be_invalid
        expect(station.errors[:name]).to include("を入力してください")
      end

      it "latitudeがない場合に無効であること" do
        station.latitude = nil
        expect(station).to be_invalid
        expect(state.errors[:latitude]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:exits).dependent(:destroy) }
    it { should have_many(:gates).dependent(:destroy) }
    it { should have_many(:routes).through(:gates) }
    it { should have_many(:railway_companies).through(:gates) }
  end
end
