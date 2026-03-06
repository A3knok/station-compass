class Gate < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station
  belongs_to :railway_company

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end

  def self.grouped_by_company
    # ①Gateを取得
    gates = Gate.includes(:railway_company).order(name: :asc)

    # ②railway_company_id でグループ化
    # group_byはハッシュを返す
    # group_by(&:railway_company_id)でもOK
    gates.group_by { |obj| obj.railway_company_id }
        # ③各グループの値を変換
        # ハッシュの値だけを変換
        .transform_values { |gates|
          # 元の各Gateオブジェクトの配列を新しい要素に変換し、新しい配列をつくる
          gates.map { |gate|
            { id: gate.id, name: gate.name }
          }
        }
  end
end
