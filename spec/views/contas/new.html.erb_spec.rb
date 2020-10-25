require 'rails_helper'

RSpec.describe "contas/new", type: :view do
  before(:each) do
    assign(:conta, Conta.new(
      usuario: nil,
      saldo: "9.99",
      numero: 1,
      ativa: false
    ))
  end

  it "renders new conta form" do
    render

    assert_select "form[action=?][method=?]", contas_path, "post" do

      assert_select "input[name=?]", "conta[usuario_id]"

      assert_select "input[name=?]", "conta[saldo]"

      assert_select "input[name=?]", "conta[numero]"

      assert_select "input[name=?]", "conta[ativa]"
    end
  end
end
