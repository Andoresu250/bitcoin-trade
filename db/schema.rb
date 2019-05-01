# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_01_193807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "bank"
    t.string "number"
    t.string "identification"
    t.bigint "document_type_id"
    t.string "identification_front"
    t.string "identification_back"
    t.string "account_certificate"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_name"
    t.index ["document_type_id"], name: "index_bank_accounts_on_document_type_id"
    t.index ["person_id"], name: "index_bank_accounts_on_person_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "body"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_blogs_on_title"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "btc_charges", force: :cascade do |t|
    t.bigint "person_id"
    t.decimal "btc"
    t.string "state"
    t.string "evidence"
    t.string "qr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_btc_charges_on_person_id"
  end

  create_table "charge_points", force: :cascade do |t|
    t.bigint "country_id"
    t.string "owner"
    t.string "account_type"
    t.string "number"
    t.string "owner_identification"
    t.string "iban"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank"
    t.index ["country_id"], name: "index_charge_points_on_country_id"
  end

  create_table "charges", force: :cascade do |t|
    t.bigint "person_id"
    t.decimal "amount"
    t.string "state", default: "pendiente"
    t.string "evidence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "charge_point_id"
    t.index ["charge_point_id"], name: "index_charges_on_charge_point_id"
    t.index ["person_id"], name: "index_charges_on_person_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale"
    t.string "time_zone"
    t.string "money_code", default: "COP"
    t.string "symbol", default: "$"
  end

  create_table "document_types", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_document_types_on_country_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_names"
    t.string "last_names"
    t.string "identification"
    t.bigint "document_type_id"
    t.bigint "country_id"
    t.string "phone"
    t.string "identification_front"
    t.string "identification_back"
    t.string "public_receipt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance", default: "0.0"
    t.decimal "btc", default: "0.0"
    t.index ["country_id"], name: "index_people_on_country_id"
    t.index ["document_type_id"], name: "index_people_on_document_type_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "person_id"
    t.decimal "btc"
    t.decimal "value"
    t.bigint "country_id"
    t.string "state", default: "pendiente"
    t.string "wallet_url"
    t.string "evidence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_purchases_on_country_id"
    t.index ["person_id"], name: "index_purchases_on_person_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "person_id"
    t.decimal "btc"
    t.decimal "value"
    t.bigint "country_id"
    t.string "state", default: "pendiente"
    t.bigint "bank_account_id"
    t.string "transfer_evidence"
    t.string "deposit_evidence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_sales_on_bank_account_id"
    t.index ["country_id"], name: "index_sales_on_country_id"
    t.index ["person_id"], name: "index_sales_on_person_id"
  end

  create_table "settings", force: :cascade do |t|
    t.decimal "last_trade_price"
    t.decimal "purchase_percentage"
    t.decimal "sale_percentage"
    t.decimal "hour_volume"
    t.integer "active_traders"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "market_cap", default: "0.0"
    t.integer "daily_transactions", default: 0
    t.integer "active_accounts", default: 0
    t.integer "supported_countries", default: 0
    t.bigint "country_id"
    t.index ["country_id"], name: "index_settings_on_country_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "profile_id"
    t.string "profile_type"
    t.string "state", default: "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "bank_accounts", "document_types"
  add_foreign_key "bank_accounts", "people"
  add_foreign_key "blogs", "users"
  add_foreign_key "btc_charges", "people"
  add_foreign_key "charge_points", "countries"
  add_foreign_key "charges", "charge_points"
  add_foreign_key "charges", "people"
  add_foreign_key "document_types", "countries"
  add_foreign_key "people", "countries"
  add_foreign_key "people", "document_types"
  add_foreign_key "purchases", "countries"
  add_foreign_key "purchases", "people"
  add_foreign_key "sales", "bank_accounts"
  add_foreign_key "sales", "countries"
  add_foreign_key "sales", "people"
  add_foreign_key "settings", "countries"
end
