class PdfService
  def self.gerar_pdf(documento, nome_arquivo = nil)
    nome_arquivo ||= "documento_#{documento.id}.pdf"

    html = ActionController::Base.new.render_to_string(
      template: "documentos/show_pdf",
      locals: { documento: documento },
      layout: "pdf"
    )

    WickedPdf.new.pdf_from_string(html, pdf_options)
  end

  private

  def self.pdf_options
    {
      page_size: "A4",
      margin: { top: 10, bottom: 10, left: 10, right: 10 },
      encoding: "UTF-8",
      print_media_type: true,
      dpi: 300
    }
  end
end
