# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_10_031703) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "pgsodium"
  create_schema "pgsodium_masks"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.pgjwt"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgsodium.pgsodium"
  enable_extension "vault.supabase_vault"

  create_table "clubs", primary_key: "Club_ID", id: :bigint, default: nil, force: :cascade do |t|
    t.boolean "Is_Super_Club", null: false
    t.timestamptz "Created_At", default: -> { "now()" }, null: false
    t.datetime "Updated_At", precision: nil
    t.string "Club_Name", null: false

    t.unique_constraint ["Club_ID"], name: "Club_Club_ID_key"
  end

  create_table "equipments", primary_key: "Equipment_ID", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "Vendor_ID", null: false
    t.bigint "Club_ID"
    t.bigint "Transaction_ID"
    t.timestamptz "Created_At", default: -> { "now()" }, null: false
    t.datetime "Edited_At", precision: nil
    t.string "Equipment_Name", null: false

    t.unique_constraint ["Equipment_ID"], name: "Equipment_Equipment_ID_key"
  end

  create_table "financial_records", primary_key: "Financial_Record_ID", id: :bigint, default: nil, force: :cascade do |t|
    t.string "Title", null: false
    t.decimal "Amount", null: false
    t.bigint "Vendor_ID"
    t.bigint "Equipment_ID"
    t.timestamptz "Created_At", default: -> { "now()" }, null: false
    t.datetime "Edited_At", precision: nil
    t.integer "Quantity", default: 1, null: false

    t.unique_constraint ["Financial_Record_ID"], name: "Financial_Record_Financial_Record_ID_key"
  end

  create_table "vendors", primary_key: "Vendor_ID", id: :bigint, default: nil, force: :cascade do |t|
    t.string "Name", null: false
    t.string "Address", null: false
    t.string "Phone_Number", null: false
    t.timestamptz "Created_At", default: -> { "now()" }, null: false
    t.datetime "Edited_At", precision: nil

    t.unique_constraint ["Vendor_ID"], name: "Vendor_Vendor_ID_key"
  end

  add_foreign_key "equipments", "clubs", column: "Club_ID", primary_key: "Club_ID", name: "Equipment_Club_ID_fkey"
  add_foreign_key "equipments", "financial_records", column: "Transaction_ID", primary_key: "Financial_Record_ID", name: "Equipment_Transaction_ID_fkey"
  add_foreign_key "equipments", "vendors", column: "Vendor_ID", primary_key: "Vendor_ID", name: "Equipment_Vendor_ID_fkey"
  add_foreign_key "financial_records", "equipments", column: "Equipment_ID", primary_key: "Equipment_ID", name: "Financial_Record_Equipment_ID_fkey"
  add_foreign_key "financial_records", "vendors", column: "Vendor_ID", primary_key: "Vendor_ID", name: "Financial_Record_Vendor_ID_fkey"
end
