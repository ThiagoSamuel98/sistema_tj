class AddCategoriaToDocumentos < ActiveRecord::Migration[8.0]
  def change
    add_column :documentos, :categoria, :string
  end
end
