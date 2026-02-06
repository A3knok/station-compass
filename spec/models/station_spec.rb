require 'rails_helper'

RSpec.describe Station, type: :model do
  describe "アソシエーション" do
    it { should have_many(:exits).dependent(:destroy) }
    it { should have_many(:gates).dependent(:destroy) }
    it { should have_many(:routes).through(:gates) }
    it { should have_many(:railway_companies).through(:gates) }
  end
end
