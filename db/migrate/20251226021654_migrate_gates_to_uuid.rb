class MigrateGatesToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # gatesテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    remove_foreign_key :routes, :gates if foreign_key_exists?(:routes, :gates)
    # 2.新しいuuidカラムを作成
    add_column :gates, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :gates, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :gates, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :gates, :uuid, :id
    #5.主キーを変更
    execute "ALTER TABLE gates DROP CONSTRAINT gates_pkey;" # 今の主キー制約を解除
    execute "ALTER TABLE gates ADD PRIMARY KEY (id);" # 新しい主キーを設定

    # ===============================
    # routesテーブルの外部キーをUUID化
    # ===============================

    # 6.新しい外部キーカラムを追加(UUID型)
    add_column :routes, :new_gate_id, :uuid
    # 7.データ移行(gatesテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE routes
      SET new_gate_id = gates.id
      FROM gates
      WHERE routes.gate_id = gates.old_id
    SQL

    # 8.古い外部キーカラムを削除
    remove_column :routes, :gate_id
    # 9.新しい外部キーカラムの名前を変更
    rename_column :routes, :new_gate_id, :gate_id
    # 10.NOT NULL制約を追加
    change_column_null :routes, :gate_id, false
    # 11.インデックスと外部キー制約を追加
    add_index :routes, :gate_id
    add_foreign_key :routes, :gates
    # 12.古いidカラムの削除
    remove_column :gates, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
