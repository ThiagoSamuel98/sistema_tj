class AddIndicadorIdToSerieHistoricaAndRemoveIndicadorColumn < ActiveRecord::Migration[8.0]
  def up
    # 1. Adiciona a coluna permitindo NULL inicialmente
    add_reference :serie_historica, :indicador, null: true, foreign_key: { to_table: :indicadores }
    
    # 2. Migra os dados existentes (associa pelo nome do indicador)
    execute <<-SQL
      UPDATE serie_historica
      SET indicador_id = (
        SELECT id FROM indicadores 
        WHERE LOWER(TRIM(indicadores.indicador)) = LOWER(TRIM(serie_historica.indicador))
        LIMIT 1
      )
    SQL
    
    # 3. Remove registros órfãos (sem correspondência em indicadores)
    execute "DELETE FROM serie_historica WHERE indicador_id IS NULL"
    
    # 4. Agora torna a coluna NOT NULL
    change_column_null :serie_historica, :indicador_id, false
    
    # 5. Remove as colunas antigas de texto
    remove_column :serie_historica, :indicador, :string
    remove_column :serie_historica, :Tipo, :string
  end

  def down
    # Reverte a migration
    add_column :serie_historica, :indicador, :string
    add_column :serie_historica, :Tipo, :string
    
    execute <<-SQL
      UPDATE serie_historica
      SET indicador = (SELECT indicador FROM indicadores WHERE indicadores.id = serie_historica.indicador_id),
          Tipo = (SELECT tipo FROM indicadores WHERE indicadores.id = serie_historica.indicador_id)
    SQL
    
    remove_foreign_key :serie_historica, :indicadores
    remove_column :serie_historica, :indicador_id
    
    change_column_null :serie_historica, :indicador, false
    change_column_null :serie_historica, :Tipo, false
  end
end
