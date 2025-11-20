class Exit < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station
end
