# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_26_221751) do

  create_table "contas", force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.decimal "saldo", default: "0.0", null: false
    t.integer "numero", null: false
    t.boolean "ativa", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["usuario_id"], name: "index_contas_on_usuario_id"
  end

  create_table "movimentacoes", force: :cascade do |t|
    t.integer "conta_id", null: false
    t.decimal "valor", null: false
    t.integer "tipo", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "conta_transferencia_id"
    t.index ["conta_id"], name: "index_movimentacoes_on_conta_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome", null: false
    t.string "cpf", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  add_foreign_key "contas", "usuarios"
  add_foreign_key "movimentacoes", "contas"
end
