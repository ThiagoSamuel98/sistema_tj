require 'csv'

namespace :import do
  desc "Importar indicadores de CSV"
  task indicadores: :environment do
    path = Rails.root.join('db/seeds/csvs/indicadores.csv')
    abort("Arquivo não encontrado: #{path}") unless File.exist?(path)

    CSV.foreach(path, headers: true, encoding: 'utf-8', col_sep: ';', quote_char: '"', strip: true) do |row|
      vals = row.to_h.transform_keys!(&:strip)

      indicador = Indicador.find_or_initialize_by(indicador: vals['Indicador'])
      indicador.tipo = vals['Tipo']
      indicador.o_que_se_mede = vals['O que se mede']
      indicador.periodicidade = vals['Periodicidade']
      indicador.onde_medir = vals['Onde medir']
      indicador.como_medir = vals['Como medir']
      indicador.tedencia = vals['Tendência']

      if indicador.save
        puts "✓ Indicador importado: #{indicador.indicador}"
      else
        warn "✗ Erro ao salvar #{vals['Indicador']}: #{indicador.errors.full_messages.join(', ')}"
      end
    end

    puts "\n✓ Importação de indicadores concluída."
  end

  desc "Importar série histórica de CSV"
  task serie_historica: :environment do
    path = Rails.root.join('db/seeds/csvs/serie_historica.csv')
    abort("Arquivo não encontrado: #{path}") unless File.exist?(path)

    CSV.foreach(path, headers: true, encoding: 'utf-8', col_sep: ';', quote_char: '"', strip: true) do |row|
      vals = row.to_h.transform_keys!(&:strip)

      indicador = vals['Indicador'].to_s.strip
      ano = vals['Ano'].to_i
      tipo = vals['Tipo'].to_s.strip
      tipo_valor = vals['Tipo valor'].to_s.strip
      valor = vals['Valor'].to_s.strip

      historico = SerieHistorica.find_or_initialize_by(indicador: indicador, ano: ano)
      historico.Tipo = tipo
      historico.Tipo_Valor = tipo_valor
      historico.Valor = valor
      historico.valor_original = valor
      historico.status = 'indisponivel' if valor.downcase.include?('sem informação')

      if historico.save
        puts "✓ Série histórica importada: #{indicador}, Ano #{ano}"
      else
        warn "✗ Erro: #{historico.errors.full_messages.join(', ')}"
      end
    end

    puts "\n✓ Importação de série histórica concluída."
  end

  desc "Importar metas de CSV"
  task metas: :environment do
    path = Rails.root.join('db/seeds/csvs/metas.csv')
    abort("Arquivo não encontrado: #{path}") unless File.exist?(path)

    CSV.foreach(path, headers: true, encoding: 'utf-8', col_sep: ';', quote_char: '"', strip: true) do |row|
      vals = row.to_h.transform_keys!(&:strip)

      indicador = vals['Indicador'].to_s.strip
      ano = vals['Ano'].to_i
      tipo = vals['Tipo'].to_s.strip
      descricao = vals['Descrição da Meta'].to_s.strip
      raw_tipo_objetivo = vals['Tipo Objetivo(Percentual ou decimal)'].to_s.strip
      resultado = vals['Resultado'].to_s.strip

      # Normalizar tipo_objetivo
      tipo_normalizado = normalize_tipo(raw_tipo_objetivo, '')
      formato = raw_tipo_objetivo.downcase.include?('percen') || raw_tipo_objetivo.include?('%') ? 'percentual' : 'decimal'

      meta = Meta.find_or_initialize_by(indicador: indicador, ano: ano)
      meta.tipo = tipo
      meta.descricao_da_meta = descricao
      meta.tipo_objetivo = tipo_normalizado
      meta.formato_objetivo = formato
      meta.resultado = resultado.to_s.tr(',', '.').to_f if resultado.present? && resultado != '-'

      if meta.save
        puts "✓ Meta importada: #{indicador} (#{ano})"
      else
        warn "✗ Erro ao salvar meta #{indicador} #{ano}: #{meta.errors.full_messages.join(', ')}"
      end
    end

    puts "\n✓ Importação de metas concluída."
  end

  desc "Importar documentos de CSV"
  task documentos: :environment do
    puts "⚠ Arquivo documentos.csv não encontrado. Pulando importação de documentos."
  end

  desc "Importar todos os dados de CSV"
  task all: :environment do
    Rake::Task['import:indicadores'].invoke
    Rake::Task['import:serie_historica'].invoke
    Rake::Task['import:metas'].invoke
    Rake::Task['import:documentos'].invoke
    puts "\n✓ Todas as importações concluídas com sucesso!"
  end
end

# Função auxiliar para normalizar percentuais e decimais
def normalize_tipo(raw_val, raw_formato)
  return nil if raw_val.nil? || raw_val.strip == ''

  s = raw_val.strip.tr(',', '.')

  if raw_formato.include?('percen') || s.include?('%')
    num = s.delete('%').to_f
    return (num > 1 ? num / 100.0 : num)
  end

  num = s.to_f
  return (num > 1 ? num / 100.0 : num) if raw_formato.empty?

  if raw_formato.include?('decim')
    return num
  end

  (num > 1 ? num / 100.0 : num)
end