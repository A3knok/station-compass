class MigrateUsersToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # usersテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    remove_foreign_key :routes, :users if foreign_key_exists?(:routes, :users)
    # 2.新しいuuidカラムを作成
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :users, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :users, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :users, :uuid, :id
    #5.主キーを変更
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey;"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    # ===============================
    # users子テーブルの外部キーをUUID化
    # ===============================

    # 6.新しい外部キーカラムを追加(UUID型)
    add_column :routes, :new_user_id, :uuid
    # 7.データ移行(userテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE routes
      SET new_user_id = users.id
      FROM users
      WHERE routes.user_id = users.old_id
    SQL

    # 8.古い外部キーカラムを削除
    remove_column :routes, :user_id
    # 9.新しい外部キーカラムの名前を変更
    rename_column :routes, :new_user_id, :user_id
    # 10.NOT NULL制約を追加
    change_column_null :routes, :user_id, false
    # 11.インデックスと外部キー制約を追加
    add_index :routes, :user_id
    add_foreign_key :routes, :users
    # 12.古いidカラムの削除
    remove_column :users, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
