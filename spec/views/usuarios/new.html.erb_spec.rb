require 'rails_helper'

RSpec.describe 'usuarios/new', type: :view do
  before(:each) do
    assign(:usuario, Usuario.new(
      nome: 'MyString',
      cpf: '533.038.130-43',
      password: '123456',
      password_digest: '123456'
    ))
  end

  it 'renders new usuario form' do
    render

    assert_select 'form[action=?][method=?]', usuarios_path, 'post' do

      assert_select 'input[name=?]', 'usuario[nome]'

      assert_select 'input[name=?]', 'usuario[cpf]'
    end
  end
end
