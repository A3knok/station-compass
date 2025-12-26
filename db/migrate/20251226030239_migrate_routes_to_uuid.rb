class MigrateRoutesToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # routesテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    # routesを参照しているテーブルがないため不要

    # 2.新しいuuidカラムを作成
    add_column :routes, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :routes, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :routes, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :routes, :uuid, :id
    # 5.主キーを変更
    execute "ALTER TABLE routes DROP CONSTRAINT routes_pkey;" # 今の主キー制約を解除
    execute "ALTER TABLE routes ADD PRIMARY KEY (id);" # 新しい主キーを設定
    # 6.古いidカラムの削除
    remove_column :routes, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
