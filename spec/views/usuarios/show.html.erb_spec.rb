require 'rails_helper'

RSpec.describe "usuarios/show", type: :view do
  before(:each) do
    @usuario = assign(:usuario, Usuario.create!(
      nome: 'Nome',
      cpf: '147.455.080-00',
      password: '123456',
      password_digest: '123456'
    ))
  end
end
