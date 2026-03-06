class EnhanceSerieHistorica < ActiveRecord::Migration[8.0]
  def change
    add_column :serie_historica, :valor_original, :string, comment: "Valor original do CSV (com %, texto, etc)"
    add_column :serie_historica, :status, :string, default: 'disponivel', comment: "disponivel, indisponivel, sem_informacao"
    
    # Renomear a coluna valor para ser sempre float (ou NULL se sem dados)
    # A coluna valor existente permanece e será preenchida durante import
  end
end