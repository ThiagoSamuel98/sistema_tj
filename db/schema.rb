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

ActiveRecord::Schema[8.0].define(version: 2026_02_25_123853) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "documentos", force: :cascade do |t|
    t.string "titulo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "categoria"
  end

  create_table "indicadores", force: :cascade do |t|
    t.string "indicador", null: false
    t.string "tipo", null: false
    t.text "o_que_se_mede"
    t.string "periodicidade"
    t.text "onde_medir"
    t.text "como_medir"
    t.string "tedencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metas", force: :cascade do |t|
    t.text "descricao_da_meta"
    t.integer "ano", null: false
    t.float "tipo_objetivo"
    t.string "formato_objetivo"
    t.float "resultado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "indicador_id", null: false
    t.index ["indicador_id"], name: "index_metas_on_indicador_id"
  end

  create_table "serie_historica", force: :cascade do |t|
    t.integer "ano", null: false
    t.string "Tipo_Valor"
    t.string "Valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "valor_original", comment: "Valor original do CSV (com %, texto, etc)"
    t.string "status", default: "disponivel", comment: "disponivel, indisponivel, sem_informacao"
    t.bigint "indicador_id", null: false
    t.index ["indicador_id"], name: "index_serie_historica_on_indicador_id"
  end

  add_foreign_key "metas", "indicadores", column: "indicador_id"
  add_foreign_key "serie_historica", "indicadores", column: "indicador_id"
end
