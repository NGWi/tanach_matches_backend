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

ActiveRecord::Schema[7.1].define(version: 2024_09_05_174200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.bigint "matched_word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matched_word_id"], name: "index_matches_on_matched_word_id"
    t.index ["word_id"], name: "index_matches_on_word_id"
  end

  create_table "verses", force: :cascade do |t|
    t.string "book"
    t.integer "chapter"
    t.integer "verse_number"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "words", force: :cascade do |t|
    t.bigint "verse_id", null: false
    t.string "text"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["verse_id"], name: "index_words_on_verse_id"
  end

  add_foreign_key "matches", "words"
  add_foreign_key "matches", "words", column: "matched_word_id"
  add_foreign_key "words", "verses"
end
