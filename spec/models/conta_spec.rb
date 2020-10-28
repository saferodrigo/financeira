# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conta, type: :model do
  let(:usuario) do
    create(:usuario)
  end

  subject { create(:conta, ativa: true, saldo: '9.99', numero: 9898, usuario_id: usuario.id) }

  describe 'Validando Conta' do
    context 'valida campos presence_of' do
      it { should belong_to(:usuario) }
      it { should have_many(:movimentacoes) }

      it { should validate_presence_of :saldo }
    end

    context 'valida numero uniqueness_of' do
      it { should validate_uniqueness_of(:numero) }
    end
  end
end
