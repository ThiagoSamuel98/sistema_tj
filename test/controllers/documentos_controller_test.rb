require "test_helper"

class DocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @documento = documentos(:one)
  end

  test "should get index" do
    get documentos_url, as: :json
    assert_response :success
  end

  test "should create documento" do
    assert_difference("Documento.count") do
      post documentos_url, params: { documento: { categoria: @documento.categoria, conteudo: @documento.conteudo, titulo: @documento.titulo } }, as: :json
    end

    assert_response :created
  end

  test "should show documento" do
    get documento_url(@documento), as: :json
    assert_response :success
  end

  test "should update documento" do
    patch documento_url(@documento), params: { documento: { categoria: @documento.categoria, conteudo: @documento.conteudo, titulo: @documento.titulo } }, as: :json
    assert_response :success
  end

  test "should destroy documento" do
    assert_difference("Documento.count", -1) do
      delete documento_url(@documento), as: :json
    end

    assert_response :no_content
  end
end
