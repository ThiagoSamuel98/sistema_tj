# Script para carregar indicadores do CSV
# Execute com: bin/rails runner db/seeds/load_indicadores_csv.rb

require 'csv'

csv_path = Rails.root.join('db/seeds/csvs/indicadores.csv')

puts "Carregando indicadores do CSV: #{csv_path}"
puts "=" * 60

count = 0
updated = 0
created = 0
errors = 0

CSV.foreach(csv_path, headers: true, col_sep: ';') do |row|
  nome = row['Indicador']&.strip&.downcase
  
  next if nome.blank?
  
  # Normaliza o nome (primeira letra maiúscula, resto minúsculo)
  nome_normalizado = nome.split.map(&:capitalize).join(' ')
  
  # Verifica se já existe (case insensitive)
  existente = Indicador.find_by("LOWER(TRIM(indicador)) = ?", nome)
  
  begin
    if existente
      # Atualiza o existente com os dados do CSV
      existente.update!(
        tipo: row['Tipo']&.downcase,
        o_que_se_mede: row['O que se mede'],
        periodicidade: row['Periodicidade'],
        onde_medir: row['Onde medir'],
        como_medir: row['Como medir'],
        tedencia: row['Tendência']
      )
      puts "✓ Atualizado: #{nome_normalizado}"
      updated += 1
    else
      # Cria novo
      Indicador.create!(
        indicador: nome_normalizado,
        tipo: row['Tipo']&.downcase,
        o_que_se_mede: row['O que se mede'],
        periodicidade: row['Periodicidade'],
        onde_medir: row['Onde medir'],
        como_medir: row['Como medir'],
        tedencia: row['Tendência']
      )
      puts "✓ Criado: #{nome_normalizado}"
      created += 1
    end
  rescue => e
    puts "✗ Erro em '#{nome_normalizado}': #{e.message}"
    errors += 1
  end
  
  count += 1
end

puts "=" * 60
puts "Total processados: #{count}"
puts "  Atualizados: #{updated}"
puts "  Criados: #{created}"
puts "  Erros: #{errors}"
puts "Total no banco: #{Indicador.count}"
puts "Com dados completos: #{Indicador.where.not(o_que_se_mede: nil).count}"
