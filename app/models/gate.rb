class Gate < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station
  belongs_to :railway_company

  def self.grouped_by_company
    gates = Gate.includes(:railway_company)

    # group_byはハッシュを返す
    # group_by(&:railway_company_id)でもOK
    gates.group_by { |obj| obj.railway_company_id }
        # ハッシュの値だけを変換
        .transform_values { |gates|
          # 元の各Gateオブジェクトの配列を新しい要素に変換し、新しい配列をつくる
          gates.map { |gate|
            { id: gate.id, name: gate.name }
          }
        }
  end
end
