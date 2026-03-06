# Script para inserir indicadores faltantes a partir da tabela metas
# Execute com: bin/rails runner db/migrate/insert_missing_indicadores_from_metas.rb

# Busca todos os indicadores únicos em metas que não existem em indicadores
missing_indicadores = ActiveRecord::Base.connection.execute <<-SQL
  SELECT DISTINCT LOWER(TRIM(indicador)) as indicador_nome
  FROM metas
  WHERE LOWER(TRIM(indicador)) NOT IN (
    SELECT LOWER(TRIM(indicador)) FROM indicadores
  )
  ORDER BY indicador_nome
SQL

puts "Encontrados #{missing_indicadores.count} indicadores faltantes em metas:"
puts "=" * 60

missing_indicadores.each do |row|
  nome = row['indicador_nome']
  
  # Tenta encontrar um indicador similar no CSV para copiar o tipo
  # Se não encontrar, usa 'nacional' como default
  tipo = 'nacional'
  
  # Verifica se é institucional baseado em palavras-chave
  if nome.downcase.include?('satisfação') || 
     nome.downcase.include?('interna') || 
     nome.downcase.include?('capacitação de servidores') ||
     nome.downcase.include?('produtividade dos magistrados') ||
     nome.downcase.include?('produtividade dos servidores') ||
     nome.downcase.include?('produtividade comparada') ||
     nome.downcase.include?('prêmio cnj') ||
     nome.downcase.include?('sentenças e decisões terminativas') ||
     nome.downcase.include?('audiência de conciliação') ||
     nome.downcase.include?('governança')
    tipo = 'institucional'
  end
  
  # Cria o indicador
  begin
    Indicador.create!(
      indicador: nome.titleize,
      tipo: tipo,
      o_que_se_mede: nil,
      periodicidade: nil,
      onde_medir: nil,
      como_medir: nil,
      tedencia: nil
    )
    puts "✓ Criado: #{nome} (tipo: #{tipo})"
  rescue => e
    puts "✗ Erro ao criar '#{nome}': #{e.message}"
  end
end

puts "=" * 60
puts "Total de indicadores no banco: #{Indicador.count}"
