class CreateHelpfulMarks < ActiveRecord::Migration[7.2]
  def change
    create_table :helpful_marks, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :route, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    # 1人のユーザーが同じルートに複数回「役にたった」をつけられないようにする
    add_index :helpful_marks, [ :user_id, :route_id ], unique: true
  end
end
