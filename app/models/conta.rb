class Conta < ApplicationRecord
  belongs_to :usuario
  has_many :movimentacoes

  validates :numero, uniqueness: true

  before_create :definir_numero

  DIAS_DA_SEMANA_TAXA_TRANSFERENCIA_MINIMA = 1..5
  HORA_TAXA_TRANSFERENCIA_MINIMA = 9..18

  def numero_formatado
    '%06d' % numero
  end

  def self.valor_taxa_transferencia(valor)
    return if valor.blank?

    taxa = 5

    unless DIAS_DA_SEMANA_TAXA_TRANSFERENCIA_MINIMA.include?(Time.now.wday) || HORA_TAXA_TRANSFERENCIA_MINIMA.include?(Time.now.hour)
      taxa = 7
    end

    taxa += 10 if valor.to_f > 1000

    taxa
  end

  private

  def definir_numero
    Conta.transaction do
      ActiveRecord::Base.connection.execute "SELECT pg_advisory_lock(10000000000);"
      self.numero = (Conta.maximum(:numero) || 0) + 1
      ActiveRecord::Base.connection.execute "SELECT pg_advisory_unlock(10000000000);"
    end
  end
end
