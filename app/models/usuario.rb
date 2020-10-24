require 'cpf_cnpj'

class Usuario < ApplicationRecord
  has_secure_password

  validates :nome, presence: true, length: { maximum: 50 }
  validates :cpf, presence: true, length: { is: 14 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validate :validar_cpf

  def cpf_formatado
    cpf_formatado = CPF.new(cpf)
    cpf_formatado.formatted
  end

  private

  def validar_cpf
    errors.add('CPF', 'inválido') unless CPF.valid?(cpf)
  end
end
