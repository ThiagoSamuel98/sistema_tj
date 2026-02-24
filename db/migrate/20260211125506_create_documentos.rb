class CreateDocumentos < ActiveRecord::Migration[8.0]
  def change
    create_table :documentos do |t|
      t.string :titulo
      t.text :conteudo
      t.string :categoria

      t.timestamps
    end
  end
end
