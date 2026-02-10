require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "バリデーション" do
    let(:contact) { build_stubbed(:contact) }

    context "正常系" do
      it "すべてのバリデーションが有効であること" do
        contact = build(:contact)
        expect(contact).to be_valid
      end
    end

    context "異常系" do
      it "subjectがない場合に無効であること" do
        contact = build(:contact, subject: nil)
        expect(contact).to be_invalid
        expect(contact.errors[:subject]).to include("を入力してください")
      end

      it "subjectが空文字の場合に無効であること" do
        contact = build(:contact, subject: "")
        expect(contact).to be_invalid
        expect(contact.errors[:subject]).to include("を入力してください")
      end

      it "bodyがない場合に無効であること" do
        contact = build(:contact, body: nil)
        expect(contact).to be_invalid
        expect(contact.errors[:body]).to include("を入力してください")
      end

      it "bodyが空文字の場合に無効であること" do
        contact = build(:contact, body: "")
        expect(contact).to be_invalid
        expect(contact.errors[:body]).to include("を入力してください")
      end

      it "bodyが10文字未満の場合に無効であること" do
        contact = build(:contact, :short_body)
        expect(contact).to be_invalid
        expect(contact.errors[:body]).to include("は10文字以上で入力してください")
      end
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
  end
end
