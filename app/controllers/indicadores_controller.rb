class IndicadoresController < ApplicationController
  # GET /indicadores
  # Lista todos os indicadores com filtros e paginação
  def index
    @filtro = params[:filtro]
    @tipo = params[:tipo]
    
    # Começa com todos os indicadores
    @indicadores = Indicador.all
    
    # Aplica filtro por tipo (nacional ou institucional)
    if @tipo.present?
      @indicadores = @indicadores.where(tipo: @tipo)
    end
    
    # Aplica filtro por nome (busca parcial, case insensitive)
    if @filtro.present?
      @indicadores = @indicadores.where("indicador ILIKE ?", "%#{@filtro}%")
    end
    
    # Ordena por nome
    @indicadores = @indicadores.order(:indicador)
    
    # Paginação: 10 registros por página
    @indicadores = @indicadores.page(params[:page]).per(10)
    
    # Conta para os filtros
    @total_com_filtro = @indicadores.count
    @total_geral = Indicador.count
  end

  # GET /indicadores/1
  # Mostra detalhes de um indicador específico
  def show
    @indicador = Indicador.find(params[:id])
    
    # Anos disponíveis para este indicador
    @anos_disponiveis = @indicador.serie_historica.pluck(:ano).sort.uniq
    @ano_selecionado = params[:ano]&.to_i || @anos_disponiveis.last || Date.today.year
    
    # Dados do ano selecionado
    @historico = @indicador.serie_historica.find_by(ano: @ano_selecionado)
    @meta = @indicador.metas.find_by(ano: @ano_selecionado)
    
    # Série histórica completa para gráfico
    @serie_completa = @indicador.serie_historica.order(:ano)
    
    # Metas históricas
    @metas_historicas = @indicador.metas.order(:ano)
  end

  # GET /indicadores/new
  # Formulário para novo indicador
  def new
    @indicador = Indicador.new
  end

  # GET /indicadores/1/edit
  # Formulário para editar indicador
  def edit
    @indicador = Indicador.find(params[:id])
  end

  # POST /indicadores
  # Cria um novo indicador
  def create
    @indicador = Indicador.new(indicador_params)
    
    if @indicador.save
      redirect_to @indicador, notice: "Indicador criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /indicadores/1
  # Atualiza um indicador existente
  def update
    @indicador = Indicador.find(params[:id])
    
    if @indicador.update(indicador_params)
      redirect_to @indicador, notice: "Indicador atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /indicadores/1
  # Remove um indicador
  def destroy
    @indicador = Indicador.find(params[:id])
    @indicador.destroy
    
    redirect_to indicadores_url, notice: "Indicador removido com sucesso!"
  end

  private
  
  # Strong Parameters - Segurança contra atribuição em massa
  # Só permite os campos listados aqui serem atualizados via form
  def indicador_params
    params.require(:indicador).permit(
      :indicador,
      :tipo,
      :o_que_se_mede,
      :periodicidade,
      :onde_medir,
      :como_medir,
      :tedencia
    )
  end
end
