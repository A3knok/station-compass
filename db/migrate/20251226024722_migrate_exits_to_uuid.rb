class MigrateExitsToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # exitsテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    remove_foreign_key :routes, :exits if foreign_key_exists?(:routes, :exits)
    # 2.新しいuuidカラムを作成
    add_column :exits, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :exits, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :exits, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :exits, :uuid, :id
    #5.主キーを変更
    execute "ALTER TABLE exits DROP CONSTRAINT exits_pkey;" # 今の主キー制約を解除
    execute "ALTER TABLE exits ADD PRIMARY KEY (id);" # 新しい主キーを設定

    # ===============================
    # routesテーブルの外部キーをUUID化
    # ===============================

    # 6.新しい外部キーカラムを追加(UUID型)
    add_column :routes, :new_exit_id, :uuid
    # 7.データ移行(gatesテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE routes
      SET new_exit_id = exits.id
      FROM exits
      WHERE routes.exit_id = exits.old_id
    SQL

    # 8.古い外部キーカラムを削除
    remove_column :routes, :exit_id
    # 9.新しい外部キーカラムの名前を変更
    rename_column :routes, :new_exit_id, :exit_id
    # 10.NOT NULL制約を追加
    change_column_null :routes, :exit_id, false
    # 11.インデックスと外部キー制約を追加
    add_index :routes, :exit_id
    add_foreign_key :routes, :exits
    # 12.古いidカラムの削除
    remove_column :exits, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
