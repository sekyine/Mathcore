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

ActiveRecord::Schema[8.0].define(version: 2025_07_18_075339) do
  create_table "battle_investigates", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "collected_cards"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "turn_count", default: 0
    t.index ["user_id"], name: "index_battle_investigates_on_user_id"
  end

  create_table "battles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "player_hp"
    t.integer "boss_hp"
    t.text "deck"
    t.text "player_hand"
    t.integer "turn"
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bonus_cards"
    t.integer "dungeon_id"
    t.index ["user_id"], name: "index_battles_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "image"
    t.integer "st"
    t.string "bunya"
    t.string "ans"
    t.string "imans1"
    t.string "imans2"
    t.string "imans3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer"
    t.string "effect_type"
    t.integer "power"
    t.string "question"
    t.string "answer"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.integer "card_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.integer "card_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "dungeons", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "boss_hp"
    t.integer "boss_attack_power"
    t.integer "boss_heal_power"
    t.integer "boss_defence_power"
    t.string "weak_bunya"
    t.string "card_bunya_filter"
    t.integer "target_level", default: 1, null: false
    t.integer "order_in_level"
    t.string "kind"
  end

  create_table "solved_cards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_solved_cards_on_card_id"
    t.index ["user_id"], name: "index_solved_cards_on_user_id"
  end

  create_table "user_cards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_user_cards_on_card_id"
    t.index ["user_id"], name: "index_user_cards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "nickname"
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "dungeon_numbers", default: [1, 2, 3, 4], null: false
    t.integer "gacha_points", default: 3
    t.integer "math_level", default: 1, null: false
    t.json "dungeon_progress"
  end

  add_foreign_key "battle_investigates", "users"
  add_foreign_key "battles", "users"
  add_foreign_key "deck_cards", "cards"
  add_foreign_key "deck_cards", "decks"
  add_foreign_key "decks", "users"
  add_foreign_key "solved_cards", "cards"
  add_foreign_key "solved_cards", "users"
  add_foreign_key "user_cards", "cards"
  add_foreign_key "user_cards", "users"
end
