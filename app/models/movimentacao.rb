class Movimentacao < ApplicationRecord
  belongs_to :conta
  belongs_to :conta_transferencia, class_name: 'Conta', optional: true, foreign_key: :conta_transferencia_id

  enum tipo: { deposito: 0, saque: 1, transferencia: 2, transferencia_recebida: 3 }

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

    tipo_descricao += " para #{conta_transferencia.usuario&.nome&.titleize}" if Movimentacao.tipos[tipo] == Movimentacao.tipos[:transferencia] && conta_transferencia.present?
    tipo_descricao += " de #{conta_transferencia.usuario&.nome&.titleize}" if Movimentacao.tipos[tipo] == Movimentacao.tipos[:transferencia_recebida] && conta_transferencia.present?

    tipo_descricao
  end
end
