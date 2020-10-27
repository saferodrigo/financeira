require 'rails_helper'

RSpec.describe 'usuarios/edit', type: :view do
  before(:each) do
    @usuario = assign(:usuario, Usuario.create!(
      nome: 'MyString',
      cpf: '641.245.630-94',
      password: '123456',
      password_digest: '123456'
    ))
  end

  it 'renders the edit usuario form' do
    render

    assert_select 'form[action=?][method=?]', usuario_path(@usuario), 'post' do
      assert_select 'input[name=?]', 'usuario[nome]'
      assert_select 'input[name=?]', 'usuario[cpf]'
    end
  end
end
