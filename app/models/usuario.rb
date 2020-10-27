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

    Movimentacao.criar(conta&.id, nil, valor, Movimentacao.tipos[:deposito])

    save!
  end

  def saque(valor)
    return false if valor.blank?

    conta.saldo -= valor.to_f

    Movimentacao.criar(conta&.id, nil, valor, Movimentacao.tipos[:saque])

    save!
  end

  def transferir(valor: nil, conta_id_transferencia: nil)
    return false if valor.blank? || conta_id_transferencia.blank?

    conta.saldo -= valor.to_f
    conta.saldo -= Conta.valor_taxa_transferencia(valor) # taxa

    # movimentacao usuario transferidor
    Movimentacao.criar(conta&.id, conta_id_transferencia, valor, Movimentacao.tipos[:transferencia])

    # movimentacao taxa usuario transferidor
    Movimentacao.criar(conta&.id, nil, Conta.valor_taxa_transferencia(valor), Movimentacao.tipos[:taxa_transferencia])
    save!

    conta_transferencia = Conta.find(conta_id_transferencia)
    conta_transferencia.saldo += valor.to_f

    # movimentacao usuario transferencia recebida
    Movimentacao.criar(conta_id_transferencia, id, valor, Movimentacao.tipos[:transferencia_recebida])

    conta_transferencia.save!
  end

  private

  def validar_cpf
    errors.add('CPF', 'inválido') unless CPF.valid?(cpf)
  end
end
