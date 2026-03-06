class CreateIndicadores < ActiveRecord::Migration[8.0]
  def change
    create_table :indicadores do |t|
      t.string :indicador, null: false
      t.string :tipo, null: false
      t.text :o_que_se_mede
      t.string :periodicidade
      t.text :onde_medir
      t.text :como_medir
      t.string :tedencia

      t.timestamps
    end
  end
end