require 'rails_helper'

RSpec.describe Gate, type: :model do
  describe "バリデーション" do
    let(:gate) { build(:gate) }

    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        expect(gate).to be_valid
      end
    end

    context "異常系" do
      it "nameがない場合に無効であること" do
        gate = build(:gate, name: nil)
        expect(gate).to be_invalid
        expect(gate.errors[:name]).to include("を入力してください")
      end

      it "nameが空文字の場合に無効であること" do
        gate = build(:gate, name: "")
        expect(gate).to be_invalid
        expect(gate.errors[:name]).to include("を入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should have_many(:routes).dependent(:destroy) }
    it { should belong_to(:station) }
    it { should belong_to(:railway_company) }
  end

  describe "Ransackの設定" do
    it "ransackable_attributesが正しく設定されていること" do
      expect(Gate.ransackable_attributes).to include("id", "name")
    end
  end

  describe "クラスメソッド" do
    describe ".grouped_by_company" do
      context "複数のRailwayCompanyに複数のGateが紐づいている場合" do
        let!(:company1) { create(:railway_company, name: "JR") }
        let!(:company2) { create(:railway_company, name: "メトロ") }

        let!(:gate1) { create(:gate, name: "北改札", railway_company: company1) }
        let!(:gate2) { create(:gate, name: "南改札", railway_company: company1) }
        let!(:gate3) { create(:gate, name: "東改札", railway_company: company2) }

        it "railway_company_idでグループ化されidとnameを含むハッシュを返すこと" do
          result = Gate.grouped_by_company

          expect(result.keys).to contain_exactly(company1.id, company2.id)
          # company1のgateが含まれているか
          expect(result[company1.id]).to contain_exactly(
            { id: gate1.id, name: "北改札" },
            { id: gate2.id, name: "南改札" }
          )
          # company2のgateが含まれているか
          expect(result[company2.id]).to contain_exactly(
            { id: gate3.id, name: "東改札" }
          )
        end
      end

      context "Gateが名前順にソートされている場合" do
        let!(:company1) { create(:railway_company, name: "JR") }
        let!(:gate_c) { create(:gate, name: "C改札", railway_company: company1) }
        let!(:gate_a) { create(:gate, name: "A改札", railway_company: company1) }
        let!(:gate_b) { create(:gate, name: "B改札", railway_company: company1) }

        it "Gateが名前順にソートされていること" do          
          result = Gate.grouped_by_company

          names = result[company1.id].map { |x| x[:name] }
          expect(names).to eq(["A改札", "B改札", "C改札"])
        end
      end

      context "Gateが存在しない場合" do
        it "空のハッシュを返すこと" do
          result = Gate.grouped_by_company
          expect(result).to eq ({})
        end
      end

      context "1つのRailwayCompanyに1つのGateのみ紐づいている場合" do
        let!(:single_company) { create(:railway_company, name: "単独会社") }
        let!(:single_gate) { create(:gate, name: "単独改札", railway_company: single_company)}

        it "正常にグループ化されること" do
          result = Gate.grouped_by_company
          expect(result.keys).to contain_exactly(single_company.id)
          expect(result[single_company.id]).to contain_exactly(
            { id: single_gate.id, name: "単独改札" }
          )
        end
      end
    end
  end
end
