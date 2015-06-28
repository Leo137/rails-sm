# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150628041528) do

  create_table "comments", force: :cascade do |t|
    t.integer  "author"
    t.text     "comment"
    t.integer  "user"
    t.integer  "song"
    t.integer  "league"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["league"], name: "index_comments_on_league"
  add_index "comments", ["song"], name: "index_comments_on_song"
  add_index "comments", ["user"], name: "index_comments_on_user"

  create_table "contestants", force: :cascade do |t|
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contestants", ["league_id"], name: "index_contestants_on_league_id"
  add_index "contestants", ["user_id"], name: "index_contestants_on_user_id"

  create_table "league_songs", force: :cascade do |t|
    t.decimal  "factor"
    t.integer  "song_id"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "league_songs", ["league_id"], name: "index_league_songs_on_league_id"
  add_index "league_songs", ["song_id"], name: "index_league_songs_on_song_id"

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "organizer_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "start_date"
    t.datetime "finish_date"
    t.boolean  "allows_join_when_started"
    t.integer  "scoring_mode"
  end

  add_index "leagues", ["organizer_id"], name: "index_leagues_on_organizer_id"

  create_table "relationship_songs", force: :cascade do |t|
    t.integer  "relationship_id"
    t.integer  "song_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "relationship_songs", ["relationship_id"], name: "index_relationship_songs_on_relationship_id"
  add_index "relationship_songs", ["song_id"], name: "index_relationship_songs_on_song_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "user_one_id"
    t.integer  "user_two_id"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["user_one_id", "user_two_id"], name: "index_relationships_on_user_one_id_and_user_two_id", unique: true
  add_index "relationships", ["user_one_id"], name: "index_relationships_on_user_one_id"
  add_index "relationships", ["user_two_id"], name: "index_relationships_on_user_two_id"

  create_table "songs", force: :cascade do |t|
    t.text     "name"
    t.string   "server_difficulty_name"
    t.string   "server_difficulty_number"
    t.integer  "server_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "pack_name"
    t.string   "description"
    t.string   "download_link"
  end

  add_index "songs", ["server_difficulty_name", "server_difficulty_number", "server_id"], name: "difficulty_index", unique: true

  create_table "user_scores", force: :cascade do |t|
    t.integer  "server_marvelous"
    t.integer  "server_perfects"
    t.integer  "server_greats"
    t.integer  "server_goods"
    t.integer  "server_bads"
    t.integer  "server_misses"
    t.integer  "server_ok"
    t.integer  "server_ng"
    t.decimal  "server_percent"
    t.integer  "server_grade"
    t.integer  "server_migs_dp_obtained"
    t.integer  "server_migs_dp_max"
    t.datetime "server_date"
    t.integer  "user_id"
    t.integer  "song_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "server_id"
    t.integer  "server_toasty_count"
    t.integer  "server_max_combo"
    t.integer  "server_mines_hit"
    t.integer  "server_mines_missed"
    t.integer  "server_score"
    t.integer  "server_timing"
    t.string   "server_mods"
  end

  add_index "user_scores", ["server_id"], name: "index_user_scores_on_server_id", unique: true
  add_index "user_scores", ["song_id"], name: "index_user_scores_on_song_id"
  add_index "user_scores", ["user_id"], name: "index_user_scores_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "server_id"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["server_id"], name: "index_users_on_server_id", unique: true

end
