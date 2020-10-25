class Conta < ApplicationRecord
  belongs_to :usuario

  validates :numero, uniqueness: true

  before_create :definir_numero

  def numero_formatado
    '%06d' % numero
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
