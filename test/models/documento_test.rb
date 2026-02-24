require "test_helper"

class DocumentoTest < ActiveSupport::TestCase
  test "nao deve salvar documento sem titulo" do
    doc = Documento.new(conteudo: "Teste", categoria: "Civil")
    assert_not doc.save, "Salvou o documento sem título!"
  end
end
