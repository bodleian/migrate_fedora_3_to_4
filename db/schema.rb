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

ActiveRecord::Schema.define(version: 20150909090045) do

  create_table "items", force: :cascade do |t|
    t.string   "identifier",      limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "object_model_id", limit: 4
    t.text     "source_url",      limit: 65535
  end

  add_index "items", ["object_model_id"], name: "index_items_on_object_model_id", using: :btree

  create_table "object_models", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "object_properties", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.boolean  "external",               default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "item_id",    limit: 4
  end

  add_index "object_properties", ["item_id"], name: "index_object_properties_on_item_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "object_model_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "namespace",       limit: 255
    t.string   "datastream",      limit: 255
    t.boolean  "multiple_type"
  end

  add_index "properties", ["object_model_id"], name: "index_properties_on_object_model_id", using: :btree

  create_table "property_values", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.integer  "item_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "namespace",  limit: 255
    t.string   "datastream", limit: 255
  end

  add_index "property_values", ["item_id"], name: "index_property_values_on_item_id", using: :btree

  add_foreign_key "items", "object_models"
  add_foreign_key "object_properties", "items"
  add_foreign_key "properties", "object_models"
  add_foreign_key "property_values", "items"
end
