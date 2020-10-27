class Movimentacao < ApplicationRecord
  belongs_to :conta
  belongs_to :conta_transferencia, class_name: 'Conta', foreign_key: :conta_transferencia_id, optional: true

  enum tipo: { deposito: 0, saque: 1, transferencia: 2, transferencia_recebida: 3, taxa_transferencia: 4 }

  validates :tipo, :valor, presence: true

  scope :by_periodo, lambda { |data_inicio, data_fim|
    if data_inicio.present? && data_fim.present?
      where('movimentacoes.created_at::date >= :data_inicio
        AND movimentacoes.created_at::date <= :data_fim',
        data_inicio: data_inicio, data_fim: data_fim)
    end
  }

  def tipo_movimentacao
    tipo_descricao = I18n.t(:"activerecord.enums.movimentacao.tipo.#{tipo}")

    return tipo_descricao unless conta_transferencia.present?

    if Movimentacao.tipos[tipo] == Movimentacao.tipos[:transferencia]
      tipo_descricao += " para #{conta_transferencia.usuario&.nome&.titleize}"
    end

    if Movimentacao.tipos[tipo] == Movimentacao.tipos[:transferencia_recebida]
      tipo_descricao += " de #{conta_transferencia.usuario&.nome&.titleize}"
    end

    tipo_descricao
  end

  def self.criar(conta_id, conta_transferencia_id, valor, tipo)
    Movimentacao.create!(
      conta_id: conta_id,
      conta_transferencia_id: conta_transferencia_id,
      valor: valor,
      tipo: tipo
    )
  end

  def sinal
    %w[saque transferencia taxa_transferencia].include?(tipo) ? '-' : '+'
  end
end
