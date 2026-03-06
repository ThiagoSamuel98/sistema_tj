# Script para remover duplicatas específicas e reordenar IDs
# Execute com: bin/rails runner db/seeds/remove_specific_duplicates.rb

puts "=" * 60
puts "REMOÇÃO DE DUPLICATAS ESPECÍFICAS"
puts "=" * 60

# 1. Remover ID 38 (duplicata do ID 22 - Taxa de Encarceramento)
puts "\n1. Removendo ID 38 (duplicata de Taxa de Encarceramento)..."
ind_38 = Indicador.find_by(id: 38)
if ind_38
  puts "   Indicador: #{ind_38.indicador}"
  ind_38.destroy
  puts "   ✓ Removido com sucesso"
else
  puts "   ✗ ID 38 não encontrado"
end

# 2. Remover ID 62 (duplicata do ID 32 - IGovTIC-JUD)
puts "\n2. Removendo ID 62 (duplicata de IGovTIC-JUD)..."
ind_62 = Indicador.find_by(id: 62)
if ind_62
  puts "   Indicador: #{ind_62.indicador}"
  ind_62.destroy
  puts "   ✓ Removido com sucesso"
else
  puts "   ✗ ID 62 não encontrado"
end

# 3. Mostrar resultado
puts "\n" + "=" * 60
puts "RESULTADO"
puts "=" * 60
puts "Total de indicadores: #{Indicador.count}"

puts "\nIndicadores em ordem de ID:"
Indicador.order(:id).each_with_index do |ind, i|
  puts "  ID #{ind.id}: #{ind.indicador} (#{ind.tipo})"
end

puts "\n" + "=" * 60
puts "NOTA: Os IDs não serão renumerados automaticamente."
puts "Para reordenar os IDs, é necessário fazer um VACUUM no banco."
puts "=" * 60
