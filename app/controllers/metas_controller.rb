class MetasController < ApplicationController
  before_action :set_meta, only: [:show, :edit, :update, :destroy]
  before_action :set_indicador, only: [:index, :new, :create]

  # GET /metas
  # GET /indicadores/1/metas
  def index
    if @indicador
      @metas = @indicador.metas.order(ano: :desc)
    else
      @metas = Meta.includes(:indicador).order(ano: :desc)
    end
    
    @metas = @metas.page(params[:page]).per(15)
  end

  # GET /metas/1
  def show
  end

  # GET /metas/new
  # GET /indicadores/1/metas/new
  def new
    @meta = @indicador ? @indicador.metas.build : Meta.new
  end

  # GET /metas/1/edit
  def edit
  end

  # POST /metas
  # POST /indicadores/1/metas
  def create
    @meta = @indicador ? @indicador.metas.build(meta_params) : Meta.new(meta_params)
    
    if @meta.save
      redirect_to @indicador ? @indicador : @meta, notice: "Meta criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /metas/1
  def update
    if @meta.update(meta_params)
      redirect_to @meta.indicador, notice: "Meta atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /metas/1
  def destroy
    @indicador = @meta.indicador
    @meta.destroy
    
    redirect_to @indicador, notice: "Meta removida com sucesso!"
  end

  private
  
  def set_meta
    @meta = Meta.find(params[:id])
  end
  
  def set_indicador
    @indicador = Indicador.find(params[:indicador_id]) if params[:indicador_id]
  end
  
  def meta_params
    params.require(:meta).permit(
      :indicador_id,
      :ano,
      :descricao_da_meta,
      :tipo_objetivo,
      :formato_objetivo,
      :resultado
    )
  end
end
