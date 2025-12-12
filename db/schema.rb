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

ActiveRecord::Schema[7.1].define(version: 2025_12_12_053014) do
  create_table "emails", force: :cascade do |t|
    t.string "sender_email", null: false
    t.string "sender_name", null: false
    t.string "recipient_email", null: false
    t.string "subject", null: false
    t.text "body_html"
    t.text "body_plain", null: false
    t.datetime "received_at", null: false
    t.boolean "is_phishing", default: false
    t.string "phishing_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_phishing"], name: "index_emails_on_is_phishing"
    t.index ["received_at"], name: "index_emails_on_received_at"
    t.index ["sender_email"], name: "index_emails_on_sender_email"
  end

  create_table "phishing_indicators", force: :cascade do |t|
    t.integer "email_id", null: false
    t.string "indicator_type", null: false
    t.string "severity", null: false
    t.text "description", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_phishing_indicators_on_email_id"
    t.index ["indicator_type", "severity"], name: "index_phishing_indicators_on_indicator_type_and_severity"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "email_id", null: false
    t.datetime "reported_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_reports_on_email_id", unique: true
  end

  create_table "threat_scores", force: :cascade do |t|
    t.integer "email_id", null: false
    t.integer "score", null: false
    t.string "risk_level", null: false
    t.datetime "calculated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_threat_scores_on_email_id", unique: true
    t.index ["risk_level"], name: "index_threat_scores_on_risk_level"
  end

  add_foreign_key "phishing_indicators", "emails"
  add_foreign_key "reports", "emails"
  add_foreign_key "threat_scores", "emails"
end
