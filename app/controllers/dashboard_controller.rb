class DashboardController < ApplicationController
  def index
    # Define o ano base para filtragem (padrão: ano atual)
    @ano = params[:ano].presence&.to_i || Date.today.year
    @anos_disponiveis = (2015..Date.today.year).to_a.reverse

    # ===========================================
    # KPIs - Indicadores Chave de Performance
    # ===========================================
    @total_indicadores = Indicador.count
    @indicadores_nacionais = Indicador.where(tipo: 'nacional').count
    @indicadores_institucionais = Indicador.where(tipo: 'institucional').count
    
    # ===========================================
    # Dados para Gráficos
    # ===========================================
    
    # Gráfico de Pizza: Indicadores por Tipo
    @indicadores_por_tipo = Indicador.group(:tipo).count
    
    # Gráfico de Linha: Evolução de registros por ano
    @evolucao_serie_historica = SerieHistorica.group(:ano).count.sort.to_h
    @evolucao_metas = Meta.group(:ano).count.sort.to_h
    
    # ===========================================
    # Dados para Tabelas
    # ===========================================
    
    # Últimos indicadores atualizados (com eager loading para performance)
    @ultimos_indicadores = Indicador
      .includes(:serie_historica, :metas)
      .order(updated_at: :desc)
      .limit(5)
    
    # Indicadores com dados no ano selecionado
    @indicadores_com_dados = Indicador
      .includes(:serie_historica, :metas)
      .where(serie_historica: { ano: @ano })
      .or(Indicador.where(metas: { ano: @ano }))
      .distinct
      .limit(10)
    
    # Carrega metas e histórico do ano selecionado (indexado por indicador_id para acesso rápido)
    @metas = Meta.where(ano: @ano).index_by(&:indicador_id)
    @historico = SerieHistorica.where(ano: @ano).index_by(&:indicador_id)
  end
end
