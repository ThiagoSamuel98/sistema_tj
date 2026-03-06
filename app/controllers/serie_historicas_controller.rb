class SerieHistoricasController < ApplicationController
  before_action :set_serie_historica, only: [:show, :edit, :update, :destroy]
  before_action :set_indicador, only: [:index, :new, :create]

  # GET /serie_historicas
  # GET /indicadores/1/serie_historicas
  def index
    if @indicador
      @serie_historicas = @indicador.serie_historica.order(ano: :desc)
    else
      @serie_historicas = SerieHistorica.includes(:indicador).order(ano: :desc)
    end
    
    @serie_historicas = @serie_historicas.page(params[:page]).per(15)
  end

  # GET /serie_historicas/1
  def show
  end

  # GET /serie_historicas/new
  # GET /indicadores/1/serie_historicas/new
  def new
    @serie_historica = @indicador ? @indicador.serie_historica.build : SerieHistorica.new
  end

  # GET /serie_historicas/1/edit
  def edit
  end

  # POST /serie_historicas
  # POST /indicadores/1/serie_historicas
  def create
    @serie_historica = @indicador ? @indicador.serie_historica.build(serie_historica_params) : SerieHistorica.new(serie_historica_params)
    
    if @serie_historica.save
      redirect_to @indicador ? @indicador : @serie_historica, notice: "Registro criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /serie_historicas/1
  def update
    if @serie_historica.update(serie_historica_params)
      redirect_to @serie_historica.indicador, notice: "Registro atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /serie_historicas/1
  def destroy
    @indicador = @serie_historica.indicador
    @serie_historica.destroy
    
    redirect_to @indicador, notice: "Registro removido com sucesso!"
  end

  private
  
  def set_serie_historica
    @serie_historica = SerieHistorica.find(params[:id])
  end
  
  def set_indicador
    @indicador = Indicador.find(params[:indicador_id]) if params[:indicador_id]
  end
  
  def serie_historica_params
    params.require(:serie_historica).permit(
      :indicador_id,
      :ano,
      :Tipo_Valor,
      :Valor,
      :valor_original,
      :status
    )
  end
end
