class CreateExits < ActiveRecord::Migration[7.2]
  def change
    create_table :exits do |t|
      t.references :station, null: false, foreign_key: true
      t.string :name
      t.string :direction
      t.timestamps
    end
  end
end
