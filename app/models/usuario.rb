require 'cpf_cnpj'

class Usuario < ApplicationRecord
  has_secure_password

  has_one :conta, class_name: 'Conta', dependent: :destroy

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
    save!
  end

  def sacar(valor)
    return false if valor.blank?

    conta.saldo -= valor.to_f
    save!
  end

  def transferir(valor, conta_id)
    return false if valor.blank? || conta_id.blank?

    conta.saldo -= valor.to_f
    save!

    conta_tranferencia = Conta.find(conta_id)
    conta_tranferencia.valor += valor.to_f
    conta_tranferencia.save!
  end

  private

  def validar_cpf
    errors.add('CPF', 'inválido') unless CPF.valid?(cpf)
  end
end
