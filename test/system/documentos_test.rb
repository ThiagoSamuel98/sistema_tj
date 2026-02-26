require "application_system_test_case"

class DocumentosTest < ApplicationSystemTestCase
  setup do
    @documento = documentos(:one)
  end

  test "visiting the index" do
    visit documentos_url
    # Trocamos 'h1' por um texto que realmente existe na sua nova dashboard
    assert_selector "p", text: "Total de Documentos"
  end

  test "should create documento" do
    visit documentos_url
    # Mudamos para o novo nome do botão
    click_on "Novo Documento"

    fill_in "Título", with: "Ofício de Teste"
    select "Sentença", from: "Categoria"
    click_on "Salvar Documento"

    assert_text "Documento criado com sucesso"
    click_on "Voltar para Documentos"
  end

  test "should update Documento" do
    visit documento_url(@documento)
    # Mudamos para o nome que você colocou no botão de editar
    click_on "Editar Documento"

    fill_in "Título", with: "Título Atualizado"
    click_on "Salvar Documento"

    assert_text "Documento atualizado com sucesso"
    click_on "Voltar para Documentos"
  end

  test "should destroy Documento" do
    visit documento_url(@documento)
    # Mudamos para o texto que definimos para a exclusão
    click_on "Excluir Permanentemente"

    assert_text "Documento excluído com sucesso"
  end
end