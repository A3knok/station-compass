class MigrateStationsToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # stationsテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    remove_foreign_key :gates, :stations if foreign_key_exists?(:gates, :stations)
    remove_foreign_key :exits, :stations if foreign_key_exists?(:exits, :stations)
    # 2.新しいuuidカラムを作成
    add_column :stations, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :stations, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :stations, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :stations, :uuid, :id
    #5.主キーを変更
    execute "ALTER TABLE stations DROP CONSTRAINT stations_pkey;" # 今の主キー制約を解除
    execute "ALTER TABLE stations ADD PRIMARY KEY (id);" # 新しい主キーを設定

    # ===============================
    # gatesテーブルの外部キーをUUID化
    # ===============================

    # 6.新しい外部キーカラムを追加(UUID型)
    add_column :gates, :new_station_id, :uuid
    # 7.データ移行(stationsテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE gates
      SET new_station_id = stations.id
      FROM stations
      WHERE gates.station_id = stations.old_id
    SQL

    # 8.古い外部キーカラムを削除
    remove_column :gates, :station_id
    # 9.新しい外部キーカラムの名前を変更
    rename_column :gates, :new_station_id, :station_id
    # 10.NOT NULL制約を追加
    change_column_null :gates, :station_id, false
    # 11.インデックスと外部キー制約を追加
    add_index :gates, :station_id
    add_foreign_key :gates, :stations

    # ===============================
    # exitsテーブルの外部キーをUUID化
    # ===============================

    # 12.新しい外部キーカラムを追加(UUID型)
    add_column :exits, :new_station_id, :uuid
    # 13.データ移行(stationsテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE exits
      SET new_station_id = stations.id
      FROM stations
      WHERE exits.station_id = stations.old_id
    SQL

    # 14.古い外部キーカラムを削除
    remove_column :exits, :station_id
    # 15.新しい外部キーカラムの名前を変更
    rename_column :exits, :new_station_id, :station_id
    # 16.NOT NULL制約を追加
    change_column_null :exits, :station_id, false
    # 17.インデックスと外部キー制約を追加
    add_index :exits, :station_id
    add_foreign_key :exits, :stations
    # 18.古いidカラムの削除
    remove_column :stations, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
