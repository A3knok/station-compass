class AddLatitudeLongitudeToStations < ActiveRecord::Migration[7.2]
  def change
    add_column :stations, :latitude, :decimal, precision: 10, scale: 6
    add_column :stations, :longitude, :decimal, precision: 10, scale: 6
  end
end
