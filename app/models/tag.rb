class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :routes, through: :taggings

  validates :name, uniqueness: true, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
