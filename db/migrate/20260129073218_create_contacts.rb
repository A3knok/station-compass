class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :subject, null: false
      t.text :body, null: false
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
