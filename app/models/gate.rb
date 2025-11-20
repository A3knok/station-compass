class Gate < ApplicationRecord
  has_many :routes, dependent: :destroy
  belongs_to :station
  belongs_to :railway_company
end
