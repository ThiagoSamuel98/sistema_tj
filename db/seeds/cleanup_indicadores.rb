# Script para limpar indicadores duplicados e sem dados completos
# Execute com: bin/rails runner db/seeds/cleanup_indicadores.rb

puts "=" * 60
puts "LIMPEZA DE INDICADORES"
puts "=" * 60

# 1. Identificar indicadores com dados COMPLETOS
completos = Indicador.where.not(o_que_se_mede: nil)
                     .where.not(periodicidade: nil)
                     .where.not(onde_medir: nil)
                     .where.not(como_medir: nil)
                     .where.not(tedencia: nil)

puts "\n✓ Indicadores com dados completos: #{completos.count}"

# 2. Identificar indicadores com dados INCOMPLETOS (serão removidos)
incompletos = Indicador.where(o_que_se_mede: nil)
                       .or(Indicador.where(periodicidade: nil))
                       .or(Indicador.where(onde_medir: nil))
                       .or(Indicador.where(como_medir: nil))
                       .or(Indicador.where(tedencia: nil))

puts "✗ Indicadores com dados incompletos: #{incompletos.count}"

# 3. Agrupar por nome normalizado (case insensitive) e manter apenas 1 por grupo
puts "\n" + "=" * 60
puts "REMOVENDO DUPLICADOS..."
puts "=" * 60

# Busca todos os nomes normalizados
nomes = completos.select("LOWER(TRIM(indicador)) as nome_normalizado").distinct

nomes.each do |n|
  nome_normal = n.nome_normalizado
  
  # Busca todos os indicadores com este nome (case insensitive)
  todos = Indicador.where("LOWER(TRIM(indicador)) = ?", nome_normal)
                   .where.not(o_que_se_mede: nil)
                   .where.not(periodicidade: nil)
                   .where.not(onde_medir: nil)
                   .where.not(como_medir: nil)
                   .where.not(tedencia: nil)
  
  if todos.count > 1
    # Mantém o primeiro, remove os outros
    manter = todos.first
    remover = todos.offset(1)
    
    remover.each do |ind|
      puts "Removendo duplicado: #{ind.indicador} (ID: #{ind.id})"
      ind.destroy
    end
  end
end

# 4. Remove todos os incompletos
puts "\n" + "=" * 60
puts "REMOVENDO INCOMPLETOS..."
puts "=" * 60

incompletos.each do |ind|
  puts "Removendo incompleto: #{ind.indicador} (ID: #{ind.id})"
  ind.destroy
end

# 5. Resultado final
puts "\n" + "=" * 60
puts "RESULTADO FINAL"
puts "=" * 60
puts "Total de indicadores no banco: #{Indicador.count}"
puts "Com dados completos: #{Indicador.where.not(o_que_se_mede: nil).count}"

# Lista todos os indicadores finais
puts "\nIndicadores mantidos:"
Indicador.all.each do |ind|
  puts "  - #{ind.indicador} (#{ind.tipo})"
end
