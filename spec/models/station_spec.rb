require 'rails_helper'

RSpec.describe Station, type: :model do
  describe "バリデーション" do
    let(:station) { build(:station) }

    context "正常系" do
      it "設定した全てのバリデーションが機能しているか" do
        expect(station).to be_valid
      end

      it "latitudeが-90の場合に有効であること" do
        expect(build(:station, :at_south_pole)).to be_valid
      end

      it "latitudeが90の場合に有効であること" do
        expect(build(:station, :at_north_pole)).to be_valid
      end

      it "longitudeが-180の場合に有効であること" do
        expect(build(:station, :at_west_dateline)).to be_valid
      end

      it "longitudeが180の場合に有効であること" do
        expect(build(:station, :at_east_dateline)).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        station = build(:station, name: nil)
        expect(station).to be_invalid
        expect(station.errors[:name]).to include("を入力してください")
      end

      it "nameが空文字の場合に無効であること" do
        station = build(:station, name: "")
        expect(station).to be_invalid
        expect(station.errors[:name]).to include("を入力してください")
      end

      it "latitudeがない場合に無効であること" do
        station = build(:station, latitude: nil)
        expect(station).to be_invalid
        expect(station.errors[:latitude]).to include("を入力してください")
      end

      it "latitudeが-90より小さい場合に無効であること" do
        station = build(:station, latitude: -100)
        expect(station).to be_invalid
        expect(station.errors[:latitude]).to include("は-90以上の値にしてください")
      end

      it "latitudeが90より大きい場合に無効であること" do
        station = build(:station, latitude: 100)
        expect(station).to be_invalid
        expect(station.errors[:latitude]).to include("は90以下の値にしてください")
      end

      it "longitudeがない場合に無効であること" do
        station = build(:station, longitude: nil)
        expect(station).to be_invalid
        expect(station.errors[:longitude]).to include("を入力してください")
      end

      it "longitudeが-180より小さい場合に無効であること" do
        station = build(:station, longitude: -200)
        expect(station).to be_invalid
        expect(station.errors[:longitude]).to include("は-180以上の値にしてください")
      end

      it "longitudeが180より大きい場合に無効であること" do
        station = build(:station, longitude: 200)
        expect(station).to be_invalid
        expect(station.errors[:longitude]).to include("は180以下の値にしてください")
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
