class DocumentosController < ApplicationController
  before_action :set_documento, only: %i[ show edit update destroy ]

# GET /documentos or /documentos.json
def index
  @documentos = Documento.all

  # Lógica de Busca: Se houver um parâmetro 'query', filtra o banco
  if params[:query].present?
    @documentos = @documentos.where("titulo LIKE ? OR categoria LIKE ?",
                                   "%#{params[:query]}%",
                                   "%#{params[:query]}%")
  end
end

  # GET /documentos/1 or /documentos/1.json
  def show
    @documento = Documento.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf { exportar_pdf } # ou render pdf direto
    end
  end

  # GET /documentos/new
  def new
    @documento = Documento.new
  end

  # GET /documentos/1/edit
  def edit
  end

  # POST /documentos or /documentos.json
  def create
    @documento = Documento.new(documento_params)
    if @documento.save
      redirect_to @documento, notice: "Documento criado."
    else
      render :new
    end
  end

  # PATCH/PUT /documentos/1 or /documentos/1.json
  def update
    respond_to do |format|
      if @documento.update(documento_params)
        format.html { redirect_to @documento, notice: "Documento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @documento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentos/1 or /documentos/1.json
  def destroy
    @documento.destroy!

    respond_to do |format|
      format.html { redirect_to documentos_path, notice: "Documento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  def exportar_pdf
    @documento = Documento.find(params[:id])
    pdf = PdfService.gerar_pdf(@documento)
    send_data(pdf, filename: "documento_#{@documento.id}.pdf", type: "application/pdf", disposition: "attachment")
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def documento_params
      params.expect(documento: [ :titulo, :categoria ])
    end
end
