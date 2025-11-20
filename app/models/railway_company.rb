class RailwayCompany < ApplicationRecord
  has_many :gates, dependent: :destroy
end
