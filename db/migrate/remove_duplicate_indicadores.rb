# Script para remover indicadores duplicados (apenas os com valores NULL)
# Execute com: bin/rails runner db/migrate/remove_duplicate_indicadores.rb

puts "Contagem antes da limpeza: #{Indicador.count}"

# Encontra indicadores duplicados por nome (case insensitive)
duplicados = ActiveRecord::Base.connection.execute <<-SQL
  SELECT i1.id as id_para_remover, i2.id as id_para_manter, i1.indicador
  FROM indicadores i1
  INNER JOIN indicadores i2 
    ON LOWER(TRIM(i1.indicador)) = LOWER(TRIM(i2.indicador))
    AND i1.id != i2.id
  WHERE i1.o_que_se_mede IS NULL 
    AND i2.o_que_se_mede IS NOT NULL
SQL

puts "\nRemovendo #{duplicados.count} indicadores duplicados..."

duplicados.each do |row|
  id_remover = row['id_para_remover']
  nome = row['indicador']
  
  begin
    Indicador.destroy(id_remover)
    puts "✓ Removido: #{nome}"
  rescue => e
    puts "✗ Erro ao remover ID #{id_remover}: #{e.message}"
  end
end

puts "\nContagem após limpeza: #{Indicador.count}"
puts "Limpeza concluída!"
