class CreateGates < ActiveRecord::Migration[7.2]
  def change
    create_table :gates do |t|
      t.string :name
      t.references :station, null: false, foreign_key: true
      t.references :railway_company, null: false, foreign_key: true
      t.timestamps
    end
  end
end
