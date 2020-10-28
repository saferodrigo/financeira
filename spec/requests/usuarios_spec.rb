# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Usuarios', type: :request do
  let(:valid_attributes) do
    attributes_for(:usuario)
  end

  let(:invalid_attributes) do
    attributes_for(:usuario, cpf: '1231231231')
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_usuario_url
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Usuario' do
        expect do
          post usuarios_url, params: { usuario: valid_attributes }
        end.to change(Usuario, :count).by(1)
      end

      it 'redirects to the created usuario' do
        post usuarios_url, params: { usuario: valid_attributes }
        expect(response).to redirect_to('/login')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Usuario' do
        expect do
          post usuarios_url, params: { usuario: invalid_attributes }
        end.to change(Usuario, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post usuarios_url, params: { usuario: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        attributes_for(:usuario)
      end

      it 'updates the requested usuario' do
        usuario = Usuario.create! valid_attributes
        patch usuario_url(usuario), params: { usuario: new_attributes }
        usuario.reload
        attributes_for(:usuario)
      end
    end
  end
end
