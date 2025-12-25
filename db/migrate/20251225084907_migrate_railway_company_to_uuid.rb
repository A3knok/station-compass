class MigrateRailwayCompanyToUuid < ActiveRecord::Migration[7.2]
  def up
    # ===============================
    # railway_companiesテーブルの主キーをuuid化
    # ===============================

    # 1.外部キー制約を一旦削除
    remove_foreign_key :gates, :railway_companies if foreign_key_exists?(:gates, :railway_companies)
    # 2.新しいuuidカラムを作成
    add_column :railway_companies, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :railway_companies, :uuid, unique: true
    # 3.古いidカラムの名前を変更
    rename_column :railway_companies, :id, :old_id
    # 4.uuidカラムの名前を変更
    rename_column :railway_companies, :uuid, :id
    #5.主キーを変更
    execute "ALTER TABLE railway_companies DROP CONSTRAINT railway_companies_pkey;" # 今の主キー制約を解除
    execute "ALTER TABLE railway_companies ADD PRIMARY KEY (id);" # 新しい主キーを設定

    # ===============================
    # 外部キーをUUID化
    # ===============================

    # 6.新しい外部キーカラムを追加(UUID型)
    add_column :gates, :new_railway_company_id, :uuid
    # 7.データ移行(userテーブルの新しいid(元uuidカラム)を参照)
    execute <<-SQL
      UPDATE gates
      SET new_railway_company_id = railway_companies.id
      FROM railway_companies
      WHERE gates.railway_company_id = railway_companies.old_id
    SQL

    # 8.古い外部キーカラムを削除
    remove_column :gates, :railway_company_id
    # 9.新しい外部キーカラムの名前を変更
    rename_column :gates, :new_railway_company_id, :railway_company_id
    # 10.NOT NULL制約を追加
    change_column_null :gates, :railway_company_id, false
    # 11.インデックスと外部キー制約を追加
    add_index :gates, :railway_company_id
    add_foreign_key :gates, :railway_companies
    # 12.古いidカラムの削除
    remove_column :railway_companies, :old_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
