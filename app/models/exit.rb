class Exit < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end
end
