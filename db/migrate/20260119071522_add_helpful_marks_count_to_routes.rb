class AddHelpfulMarksCountToRoutes < ActiveRecord::Migration[7.2]
  def up
    add_column :routes, :helpful_marks_count, :integer, default: 0, null: false

    # 既存レコードのカウントを初期化(SQLで直接更新)
    # where句はすべての対象業に同じ値を設定してしまうため今回のケースでは使用しない
    execute <<-SQL
      UPDATE routes
      SET helpful_marks_count = (
        SELECT COUNT(*) -- 各行ごとに異なる値を計算
        FROM helpful_marks
        WHERE helpful_marks.route_id = routes.id -- 現在処理中の行のidを参照
      )
    SQL
  end

  def down
    remove_column :routes, :helpful_marks_count
  end
end
