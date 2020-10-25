require 'rails_helper'

RSpec.describe "contas/index", type: :view do
  before(:each) do
    @usuario = assign(:usuario, Usuario.create!(
      nome: 'teste',
      cpf: CPF.generate(true),
      password: '123123'
    ))

    assign(:contas, [
      Conta.create!(
        usuario: @usuario,
        saldo: "9.99",
        numero: 2,
        ativa: false
      ),
      Conta.create!(
        usuario: @usuario,
        saldo: "9.99",
        numero: 2,
        ativa: false
      )
    ])
  end

  it "renders a list of contas" do
    # render
    # assert_select "tr>td", text: @usuario&.nome&.to_s, count: 2
    # assert_select "tr>td", text: "9.99".to_s, count: 2
    # assert_select "tr>td", text: 2.to_s, count: 2
    # assert_select "tr>td", text: false.to_s, count: 2
  end
end
