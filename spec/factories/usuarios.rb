# frozen_string_literal: true
require 'cpf_cnpj'

FactoryBot.define do
  factory :usuario do
    name { Faker::Name.name }
    cpf { CPF.generate(true) }
    password { Faker::Alphanumeric.alphanumeric(number: 6) }
  end
end
