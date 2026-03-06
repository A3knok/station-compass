class Exit < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station

  validates :name, presence: true
  validates :direction, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end

  def display_name
    "#{name} (#{direction})"
  end
end
