class Category < ApplicationRecord
  has_many :routes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    [ "routes" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
