class CreateRailwayCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :railway_companies do |t|
      t.string :name
      t.timestamps
    end
  end
end
