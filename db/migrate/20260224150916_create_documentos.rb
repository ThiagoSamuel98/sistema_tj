class CreateDocumentos < ActiveRecord::Migration[8.0]
  def change
    create_table :documentos do |t|
      t.string :titulo

      t.timestamps
    end
  end
end
