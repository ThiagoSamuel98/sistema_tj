class CreateSerieHistorica < ActiveRecord::Migration[8.0]
  def change
    create_table :serie_historica do |t|
      t.string :indicador, null: false
      t.string :Tipo, null: false
      t.integer :ano, null: false
      t.string :Tipo_Valor
      t.string :Valor

      t.timestamps
    end
  end
end