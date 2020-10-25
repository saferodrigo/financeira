require 'rails_helper'

RSpec.describe "contas/show", type: :view do
  before(:each) do
    @usuario = assign(:usuario, Usuario.create!(
      nome: 'teste',
      cpf: CPF.generate(true),
      password: '123123'
    ))

    @conta = assign(:conta, Conta.create!(
      usuario: @usuario,
      saldo: "9.99",
      numero: 2,
      ativa: false
    ))
  end

  it "renders attributes in <p>" do
    # render
    # expect(rendered).to match(//)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/false/)
  end
end
