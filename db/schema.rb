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

ActiveRecord::Schema[7.1].define(version: 2024_02_25_093721) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_records", force: :cascade do |t|
    t.string "type"
    t.float "value"
    t.string "unit"
    t.string "source"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["starts_at", "ends_at", "type"], name: "index_data_records_on_starts_at_and_ends_at_and_type", unique: true
    t.index ["type"], name: "index_data_records_on_type"
  end

end
