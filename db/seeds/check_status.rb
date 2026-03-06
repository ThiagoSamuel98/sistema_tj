# Script para verificar o estado atual do banco
# Execute com: bin/rails runner db/seeds/check_status.rb

puts "=" * 60
puts "STATUS DO BANCO DE DADOS"
puts "=" * 60

# 1. Indicadores
puts "\n1. INDICADORES:"
total_ind = Indicador.count
completos = Indicador.where.not(o_que_se_mede: nil).count
incompletos = total_ind - completos

puts "   Total: #{total_ind}"
puts "   Completos: #{completos}"
puts "   Incompletos: #{incompletos}"

if incompletos > 0
  puts "\n   Indicadores incompletos:"
  Indicador.where(o_que_se_mede: nil).each do |ind|
    puts "      - ID #{ind.id}: #{ind.indicador}"
  end
end

# 2. Serie Historica
puts "\n2. SERIE_HISTORICA:"
total_sh = SerieHistorica.count
com_fk = SerieHistorica.where.not(indicador_id: nil).count
sem_fk = total_sh - com_fk

puts "   Total: #{total_sh}"
puts "   Com indicador_id: #{com_fk}"
puts "   Sem indicador_id: #{sem_fk}"

# 3. Metas
puts "\n3. METAS:"
total_metas = Meta.count
com_fk_metas = Meta.where.not(indicador_id: nil).count
sem_fk_metas = total_metas - com_fk_metas

puts "   Total: #{total_metas}"
puts "   Com indicador_id: #{com_fk_metas}"
puts "   Sem indicador_id: #{sem_fk_metas}"

# 4. Verificar inconsistências
puts "\n" + "=" * 60
puts "INCONSISTÊNCIAS"
puts "=" * 60

# Serie historica com indicador_id que não existe
sh_orfaos = SerieHistorica.left_joins(:indicador).where(indicadores: { id: nil }).count
puts "\nSerie_historica órfãos (indicador_id inválido): #{sh_orfaos}"

# Metas com indicador_id que não existe
metas_orfaos = Meta.left_joins(:indicador).where(indicadores: { id: nil }).count
puts "Metas órfãos (indicador_id inválido): #{metas_orfaos}"

# Indicadores sem uso
indicadores_sem_uso = Indicador.left_joins(:serie_historica, :metas)
  .where(serie_historica: { id: nil })
  .where(metas: { id: nil })
  .distinct
  .count

puts "Indicadores sem uso (sem serie_historica ou metas): #{indicadores_sem_uso}"

puts "\n" + "=" * 60
