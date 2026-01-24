class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :routes, through: :taggings

  validates :name, uniqueness: true, presence: true
  validates :name, format: {
    without: /,/,
    message: "にカンマを含めることはできません"
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
