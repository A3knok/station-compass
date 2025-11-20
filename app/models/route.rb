class Route < ApplicationRecord
  belongs_to :user
  belongs_to :gate
  belongs_to :exit

  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :estimated_time, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
