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

ActiveRecord::Schema[8.0].define(version: 2025_05_13_140212) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "medications", force: :cascade do |t|
    t.string "substance"
    t.float "dosage"
    t.string "measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["substance", "dosage"], name: "index_medications_on_substance_and_dosage", unique: true
  end

  create_table "physician_patients", force: :cascade do |t|
    t.bigint "physician_id", null: false
    t.bigint "patient_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_physician_patients_on_patient_id"
    t.index ["physician_id", "patient_id"], name: "index_physician_patients_on_physician_id_and_patient_id", unique: true
    t.index ["physician_id"], name: "index_physician_patients_on_physician_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "medication_id", null: false
    t.integer "action_type"
    t.float "quantity"
    t.string "time"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_user_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "physician_id", null: false
    t.index ["current_user_id"], name: "index_prescriptions_on_current_user_id"
    t.index ["medication_id"], name: "index_prescriptions_on_medication_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
    t.index ["physician_id"], name: "index_prescriptions_on_physician_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "physician_patients", "users", column: "patient_id"
  add_foreign_key "physician_patients", "users", column: "physician_id"
  add_foreign_key "prescriptions", "medications"
  add_foreign_key "prescriptions", "users", column: "current_user_id"
  add_foreign_key "prescriptions", "users", column: "patient_id"
  add_foreign_key "prescriptions", "users", column: "physician_id"
end
