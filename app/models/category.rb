class Category < ApplicationRecord
  has_many :routes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
