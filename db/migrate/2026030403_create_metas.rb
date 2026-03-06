class CreateMetas < ActiveRecord::Migration[8.0]
  def change
    create_table :metas do |t|
      t.string :indicador, null: false
      t.string :tipo, null: false
      t.text :descricao_da_meta
      t.integer :ano, null: false
      t.float :tipo_objetivo
      t.string :formato_objetivo # 'Percentual' ou 'decimal'
      t.float :resultado

      t.timestamps
    end
  end
end