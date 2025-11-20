class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gate, null: false, foreign_key: true
      t.references :exit, null: false, foreign_key: true
      t.integer :estimated_time
      t.text :description
      t.timestamps
    end
  end
end
