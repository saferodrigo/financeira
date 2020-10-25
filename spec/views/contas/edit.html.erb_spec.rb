require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe "contas/edit", type: :view do
  before(:each) do
    @usuario = assign(:usuario, Usuario.create!(
      nome: 'teste',
      cpf: CPF.generate(true),
      password: '123123'
    ))

    @conta = assign(:conta, Conta.create!(
      usuario: @usuario,
      saldo: "9.99",
      numero: 1,
      ativa: false
    ))
  end

  it "renders the edit conta form" do
    render

    assert_select "form[action=?][method=?]", conta_path(@conta), "post" do

      assert_select "input[name=?]", "conta[usuario_id]"

      assert_select "input[name=?]", "conta[saldo]"

      assert_select "input[name=?]", "conta[numero]"

      assert_select "input[name=?]", "conta[ativa]"
    end
  end
end
