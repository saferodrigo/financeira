# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Usuario, type: :model do
  subject { build :usuario }

  describe 'Validando Usuario' do
    context 'valida campos presence_of' do
      it { should validate_presence_of :nome }
      it { should validate_presence_of :cpf }
    end

    context 'valida campos length_of' do
      it { should validate_length_of(:cpf).is_equal_to(14) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context 'valida cpf uniqueness_of' do
      # CPF com 14 caracteres hexadecimal, pois o matcher acusa erro para strings com numeros apenas
      it do
        usuario1 = build(:usuario, cpf: '1234567890abcd')

        expect(usuario1).to validate_uniqueness_of(:cpf) # it { should validate_uniqueness_of(:cpf) }
      end
    end
  end
end
