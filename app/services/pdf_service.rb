class PdfService
  def self.gerar_pdf(documento, nome_arquivo)
    WickedPdf.new.pdf_from_string(
      renderizar_html(documento),
      pdf_options(nome_arquivo)
    )
  end

  private

  def self.renderizar_html(documento)
    ActionController::Base.new.render_to_string(
      template: 'documentos/show_pdf',
      locals: { documento: documento },
      layout: 'pdf'
    )
  end

  def self.pdf_options(nome_arquivo)
    {
      page_size: 'A4',
      margin: { top: 10, bottom: 10, left: 10, right: 10 },
      encoding: 'UTF-8',
      print_media_type: true
    }
  end
end