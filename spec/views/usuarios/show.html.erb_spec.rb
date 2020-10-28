# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usuarios/show', type: :view do
  before(:each) do
    @usuario = assign(:usuario, create(:usuario))
  end

  it 'displays the usuario with id: 1' do
    controller.extra_params = { id: @usuario.id }

    expect(controller.request.fullpath).to eq usuario_path(@usuario)
  end
end
