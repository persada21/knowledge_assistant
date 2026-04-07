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

ActiveRecord::Schema[8.0].define(version: 2026_04_07_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chunks", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.text "body", null: false
    t.integer "chunk_index", null: false
    t.jsonb "vector", default: {}
    t.integer "word_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "chunk_index"], name: "index_chunks_on_document_id_and_chunk_index"
    t.index ["document_id"], name: "index_chunks_on_document_id"
    t.index ["vector"], name: "index_chunks_on_vector", using: :gin
  end

  create_table "documents", force: :cascade do |t|
    t.string "title", null: false
    t.text "original_text", null: false
    t.integer "chunk_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.index ["status"], name: "index_documents_on_status"
  end

  add_foreign_key "chunks", "documents"
end
