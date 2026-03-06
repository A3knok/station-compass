class CreateTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :taggings, id: :uuid do |t|
      t.references :tag, type: :uuid, null: false, foreign_key: true
      t.references :route, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    # １つのルートに同じタグをつけられないようにする
    add_index :taggings, [ :tag_id, :route_id ], unique: true
  end
end
