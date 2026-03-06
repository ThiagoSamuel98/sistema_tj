class AddIndicadorIdToMetasAndRemoveIndicadorColumn < ActiveRecord::Migration[8.0]
  def up
    # 1. Adiciona a coluna permitindo NULL inicialmente
    add_reference :metas, :indicador, null: true, foreign_key: { to_table: :indicadores }
    
    # 2. Migra os dados existentes (associa pelo nome do indicador)
    execute <<-SQL
      UPDATE metas
      SET indicador_id = (
        SELECT id FROM indicadores 
        WHERE LOWER(TRIM(indicadores.indicador)) = LOWER(TRIM(metas.indicador))
        LIMIT 1
      )
    SQL
    
    # 3. Remove registros órfãos (sem correspondência em indicadores)
    execute "DELETE FROM metas WHERE indicador_id IS NULL"
    
    # 4. Agora torna a coluna NOT NULL
    change_column_null :metas, :indicador_id, false
    
    # 5. Remove as colunas antigas de texto
    remove_column :metas, :indicador, :string
    remove_column :metas, :tipo, :string
  end

  def down
    # Reverte a migration
    add_column :metas, :indicador, :string
    add_column :metas, :tipo, :string
    
    execute <<-SQL
      UPDATE metas
      SET indicador = (SELECT indicador FROM indicadores WHERE indicadores.id = metas.indicador_id),
          tipo = (SELECT tipo FROM indicadores WHERE indicadores.id = metas.indicador_id)
    SQL
    
    remove_foreign_key :metas, :indicadores
    remove_column :metas, :indicador_id
    
    change_column_null :metas, :indicador, false
    change_column_null :metas, :tipo, false
  end
end
