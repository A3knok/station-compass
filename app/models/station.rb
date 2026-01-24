class Station < ApplicationRecord
  has_many :exits, dependent: :destroy
  has_many :gates, dependent: :destroy
  has_many :routes, through: :gates
end
