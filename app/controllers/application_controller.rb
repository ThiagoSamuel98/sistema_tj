class ApplicationController < ActionController::Base
  # Garante que o sistema use tecnologias modernas do navegador
  allow_browser versions: :modern

  # TRATAMENTO DE ERRO: Se o registro não for encontrado, executa o método 'record_not_found'
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    # Redireciona para a página inicial com um alerta amigável
    redirect_to root_path, alert: "O documento solicitado não foi encontrado ou foi excluído."
  end
end
