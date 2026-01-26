class RailwayCompany < ApplicationRecord
  has_many :gates, dependent: :destroy
  has_many :stations, through: :gates

  def self.grouped_by_station
    joins(:gates)
      .select("railway_companies.id", "railway_companies.name", "gates.station_id")
      .order("railway_companies.name")
      .group_by{ |obj| obj.station_id }
      .transform_values { |companies|
        companies.map { |company|
          { id: company.id, name:company.name }
        }
      }
  end
end
