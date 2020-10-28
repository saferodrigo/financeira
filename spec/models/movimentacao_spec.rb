# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movimentacao, type: :model do
  subject { build :movimentacao }

  describe 'Validando Movimentacao' do
    context 'valida campos presence_of' do
      it { should belong_to(:conta) }
      it { should belong_to(:conta_transferencia).class_name('Conta').with_foreign_key('conta_transferencia_id').optional }

      it { should validate_presence_of :tipo }
      it { should validate_presence_of :valor }
    end
  end
end
