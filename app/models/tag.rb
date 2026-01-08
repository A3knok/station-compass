class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :routes, through: :taggings

  validates :name, uniqueness: true, presence: true
end
