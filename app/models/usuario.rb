require 'cpf_cnpj'

class Usuario < ApplicationRecord
  has_secure_password

  has_one :conta, class_name: 'Conta', dependent: :restrict_with_exception

  validates :nome, presence: true, length: { maximum: 50 }
  validates :cpf, presence: true, length: { is: 14 }, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validate :validar_cpf

  accepts_nested_attributes_for :conta

  def cpf_formatado
    cpf_formatado = CPF.new(cpf)
    cpf_formatado.formatted
  end

  def encerrar_conta
    conta.ativa = false

    save!
  end

  def depositar(valor)
    return false if valor.blank?

    conta.saldo += valor.to_f
    Movimentacao.create!(
      conta_id: conta&.id,
      valor: valor,
      tipo: Movimentacao.tipos[:deposito]
    )

    save!
  end

  def saque(valor)
    return false if valor.blank?

    conta.saldo -= valor.to_f
    Movimentacao.create!(
      conta_id: conta&.id,
      valor: valor,
      tipo: Movimentacao.tipos[:saque]
    )

    save!
  end

  def transferir(valor: nil, conta_id_transferencia: nil)
    return false if valor.blank? || conta_id_transferencia.blank?

    conta.saldo -= valor.to_f
    Movimentacao.create!(
      conta_id: conta&.id,
      valor: valor,
      tipo: Movimentacao.tipos[:transferencia],
      conta_transferencia_id: conta_id_transferencia
    )
    save!

    conta_tranferencia = Conta.find(conta_id_transferencia)
    conta_tranferencia.saldo += valor.to_f
    Movimentacao.create!(
      conta_id: conta_tranferencia&.id,
      valor: valor,
      tipo: Movimentacao.tipos[:transferencia_recebida],
      conta_transferencia_id: id
    )

    conta_tranferencia.save!
  end

  private

  def validar_cpf
    errors.add('CPF', 'inválido') unless CPF.valid?(cpf)
  end
end
