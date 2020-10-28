# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usuarios/new', type: :view do
  before(:each) do
    assign(:usuario, build(:usuario))
  end

  it 'renders new usuario form' do
    render

    assert_select 'form[action=?][method=?]', usuarios_path, 'post' do
      assert_select 'input[name=?]', 'usuario[nome]'

      assert_select 'input[name=?]', 'usuario[cpf]'
    end
  end
end
